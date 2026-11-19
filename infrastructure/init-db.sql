-- Local development only. Production role passwords come from the deployment secret store.
CREATE ROLE lifeverse_app LOGIN PASSWORD 'lifeverse_app_local' NOSUPERUSER NOCREATEDB NOCREATEROLE NOBYPASSRLS;
GRANT CONNECT ON DATABASE lifeverse TO lifeverse_app;
GRANT USAGE ON SCHEMA public TO lifeverse_app;
ALTER DEFAULT PRIVILEGES FOR ROLE lifeverse IN SCHEMA public
  GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO lifeverse_app;
