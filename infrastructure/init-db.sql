-- Local development only. Production role passwords come from the deployment secret store.
DO $$ BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'lifeverse_app') THEN
    CREATE ROLE lifeverse_app LOGIN PASSWORD 'lifeverse_app_local' NOSUPERUSER NOCREATEDB NOCREATEROLE NOBYPASSRLS;
  END IF;
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'lifeverse_dispatcher') THEN
    CREATE ROLE lifeverse_dispatcher LOGIN PASSWORD 'dispatcher_local' NOSUPERUSER NOCREATEDB NOCREATEROLE NOBYPASSRLS;
  END IF;
END $$;
GRANT CONNECT ON DATABASE lifeverse TO lifeverse_app;
GRANT USAGE ON SCHEMA public TO lifeverse_app;
GRANT CONNECT ON DATABASE lifeverse TO lifeverse_dispatcher;
GRANT USAGE ON SCHEMA public TO lifeverse_dispatcher;
ALTER DEFAULT PRIVILEGES FOR ROLE lifeverse IN SCHEMA public
  GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO lifeverse_app;
