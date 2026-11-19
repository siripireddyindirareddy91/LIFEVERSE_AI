import math
import json
from datetime import datetime, timezone
from decimal import Decimal, InvalidOperation
from fastapi import HTTPException
import httpx
from app.config import get_settings
from app.automation.schemas import External


def request_json(
    method, url, *, headers=None, params=None, data=None, payload=None, transport=None
):
    try:
        with httpx.Client(
            timeout=httpx.Timeout(15, connect=5), follow_redirects=False, transport=transport
        ) as client:
            with client.stream(
                method, url, headers=headers, params=params, data=data, json=payload
            ) as response:
                content = bytearray()
                for part in response.iter_bytes():
                    content.extend(part)
                    if len(content) > 512000:
                        raise ValueError("Response limit")
                if response.status_code >= 400:
                    raise HTTPException(
                        503,
                        "The provider could not complete the request. Reconnect or retry later.",
                    )
                if response.status_code >= 300:
                    raise ValueError("Redirect denied")
                result = json.loads(content)
                if not isinstance(result, (dict, list)):
                    raise ValueError()
                return result
    except HTTPException:
        raise
    except (httpx.HTTPError, ValueError, KeyError, TypeError) as error:
        raise HTTPException(
            503, "The external provider is unavailable or returned invalid data."
        ) from error


def fetch(spec: External, transport=None):
    if not get_settings().external_apis_enabled:
        raise HTTPException(503, "Public external APIs are disabled in server configuration.")
    if spec.api == "weather":
        value = request_json(
            "GET",
            "https://api.open-meteo.com/v1/forecast",
            params={
                "latitude": spec.latitude,
                "longitude": spec.longitude,
                "current": "temperature_2m,weather_code",
                "timezone": "UTC",
                "forecast_days": 1,
            },
            transport=transport,
        )
        current = value.get("current", {})
        temperature = current.get("temperature_2m")
        if (
            not isinstance(temperature, (int, float))
            or isinstance(temperature, bool)
            or not math.isfinite(temperature)
        ):
            raise HTTPException(503, "Weather data was incomplete.")
        return {
            "provider": "Open-Meteo",
            "source_url": "https://open-meteo.com/",
            "observed_at": current.get("time"),
            "temperature_c": temperature,
            "weather_code": current.get("weather_code"),
            "fetched_at": datetime.now(timezone.utc).isoformat(),
            "notice": "Model weather data, not a safety forecast. Check provider terms before commercial use.",
        }
    value = request_json(
        "GET",
        f"https://api.frankfurter.dev/v2/rate/{spec.base.lower()}/{spec.quote.lower()}",
        transport=transport,
    )
    try:
        rate = Decimal(str(value["rate"]))
        if not rate.is_finite() or rate <= 0:
            raise ValueError()
    except (KeyError, ValueError, InvalidOperation, TypeError) as error:
        raise HTTPException(503, "Reference-rate data was incomplete.") from error
    return {
        "provider": "Frankfurter",
        "source_url": "https://frankfurter.dev/",
        "base": spec.base,
        "quote": spec.quote,
        "rate": str(rate),
        "rate_date": value.get("date"),
        "fetched_at": datetime.now(timezone.utc).isoformat(),
        "notice": "Reference exchange rate, not a live market quote or financial recommendation.",
    }
