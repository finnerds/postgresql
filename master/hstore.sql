# Because both template1 and the user postgres database have already been created,
# we need to create the hstore extension in template1 and then recreate the postgres database.
#
# Running CREATE EXTENSION in both template1 and postgres can lead to
# the extensions having different eid's.
#
# SELECT * FROM pg_available_extension_versions WHERE name ='hstore';
#
# CREATE EXTENSION IF NOT EXISTS hstore WITH VERSION 1.5;
CREATE EXTENSION IF NOT EXISTS hstore;
