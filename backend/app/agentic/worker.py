import time
import threading
from uuid import uuid4
from sqlalchemy.exc import SQLAlchemyError
from app.agentic.queue import claim, dispatcher_engine, heartbeat, verify_dispatcher
from app.agentic.runtime import process_claim


def main():
    engine = dispatcher_engine()
    verify_dispatcher(engine)
    worker_id = uuid4()
    stop = threading.Event()

    def pulse():
        while not stop.wait(15):
            try:
                heartbeat(worker_id, engine)
            except SQLAlchemyError:
                pass  # The online indicator expires until connectivity recovers.

    thread = threading.Thread(target=pulse, daemon=True)
    thread.start()
    try:
        while True:
            try:
                job = claim(worker_id, engine)
                if job is None:
                    time.sleep(2)
                else:
                    process_claim(job)
            except SQLAlchemyError:
                print("Agent database temporarily unavailable; retrying.", flush=True)
                time.sleep(5)
    except KeyboardInterrupt:
        pass
    finally:
        stop.set()
        thread.join(timeout=2)
        engine.dispose()


if __name__ == "__main__":
    main()
