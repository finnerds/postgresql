# Postgresql logical replication

[![Docker Build Status](https://img.shields.io/docker/cloud/build/finnerds/standbyql.svg)]() - Master

[![Docker Build Status](https://img.shields.io/docker/cloud/build/finnerds/postgresql.svg)]() - Standby

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document and all other documents within this repository are to be interpreted as described in RFC 2119.

Version 0.1.0

## Introduction

Logical replication in PostgreSQL allows users to perform a replication of tables and open a standby for writes of all table within a database. Whereas physical replication in PostgreSQL is a block level replication. In this case, each database in the master is replicated to a standby, and the standby is not open for writes ("read-only"). 

With logical replication, a standby can have replication enabled from multiple masters. This could be helpful in situations where you need to replicate data from several PostgreSQL databases (OLTP) to a single PostgreSQL server for reporting and data warehousing.

One of the biggest advantages of logical over streaming replication is that logical replication allows us to replicate changes from an older version PostgreSQL to a later version. 

The following steps show you how to stream replicate replicate postgresql data between masters and standby, as how in the simplified "ascii-art":

    cluster_a_master 
    |--> standby_a_1 
    |--> standby_a_2 
    |--> standby_a_3 

## Steps to check your setup

### To start (one master, and three "standby")

     $ docker-compose up --build --scale standby_a=3"

### To see running (health: starting, healhty) 

     $ docker ps

### To Login into DB

With a temp available portnumber, you should remove it within a production setup, and use a docker-swarm network for your internal connection:

     $ psql -h 127.0.0.1 -U postgres -p 5432

### To Check 

Run the "Postgres SQL" commands below at the prompt, and check each time the result:

     SELECT * FROM pg_stat_replication;
     SELECT application_name, state, sync_priority, sync_state FROM pg_stat_replication;

### To Test

Create a table (in your master instance) and insert some data into it

     CREATE TABLE test_replication (data varchar(100));
     INSERT INTO test_replication VALUES ('https://thecatapi.com/');
     INSERT INTO test_replication VALUES ('https://www.asciiart.eu/animals/cows');
     INSERT INTO test_replication VALUES ('pg_cluster replication test successful');

### To Login into container

If you like to check the images without opening the ports, as in the first master instance within docker-compose.yml you can do get into an docker image id via e.g. "exec -it image_id"

     $ docker ps
     $ docker exec -it 2a5929305ca9 sh

but replace "2a5929305ca9" with the image id you see when you enter "$ docker ps".

Login into to the different instances, and check how fast databases, tables, and data is replicated. 
Check data on the 'test_replication' table with postgres query below.

Test (in your "read-only") standby what was replicated

     SELECT * FROM test_replication;

Test the setup information of the standby or logical replicating master

     SELECT * FROM pg_stat_replication;
     
### HSTORE

Postgresql supports the adding of extensions via SQL commands or shell scripts during the installation. The repository builds by default postgresql with HSTORE support via the included SQL command.

    hstore.sql

### HEALTHCHECK

Both, "stack.yml" and "docker-compose.yml" include a healthcheck of master and standby

    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

## References

- [Postgres - Logical Replication](https://www.postgresql.org/docs/current/logical-replication-publication.html)
- [Streaming_Replication](https://wiki.postgresql.org/wiki/Streaming_Replication)
- [Replication between postgresql versions using-logical replication](https://www.percona.com/blog/2019/04/04/replication-between-postgresql-versions-using-logical-replication/)
- [Postgres Replication, with SSL](https://blog.raveland.org/post/postgresql_sr/)
- [Postgres Replication is "simple"](https://scalegrid.io/blog/getting-started-with-postgresql-streaming-replication/)
- [Logical replication with Postgres](http://yallalabs.com/linux/how-to-setup-a-logical-replication-on-postgresql-10/)
