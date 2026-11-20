"""Response policy for private APIs, including early request-limit errors."""


class PrivateResponsePolicy:
    def __init__(self, app):
        self.app = app

    async def __call__(self, scope, receive, send):
        if scope["type"] != "http":
            return await self.app(scope, receive, send)

        async def private_send(message):
            if message["type"] == "http.response.start":
                headers = {}
                headers[b"x-content-type-options"] = b"nosniff"
                headers[b"referrer-policy"] = b"no-referrer"
                if scope["path"].startswith("/api/"):
                    headers[b"cache-control"] = b"no-store"
                    headers[b"x-frame-options"] = b"DENY"
                    headers[b"content-security-policy"] = (
                        b"default-src 'none'; frame-ancestors 'none'"
                    )
                original = [
                    (key, value) for key, value in message.get("headers", []) if key not in headers
                ]
                message = {**message, "headers": original + list(headers.items())}
            await send(message)

        await self.app(scope, receive, private_send)
