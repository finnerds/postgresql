# PostgreSQL - Logical Replication

[![Docker Build Status](https://img.shields.io/docker/cloud/build/finnerds/postgresql.svg)]() - [Master](https://github.com/finnerds/postgresql/tree/master/master)

[![Docker Build Status](https://img.shields.io/docker/cloud/build/finnerds/standbyql.svg)]() - [Standby](https://github.com/finnerds/postgresql/tree/develop/standby)

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document and all other documents within this repository are to be interpreted as described in RFC 2119.

Version 0.1.0

## Introduction

Logical replication in PostgreSQL allows users to perform a replication of tables by automatically opening a standby of all tables within a database for each write operation, whereas physical replication in PostgreSQL is a block level replication. In this case, each database in the master is replicated to a standby, and a standby is not open for write operations ("read-only").

With logical replication, a standby can have replication enabled from multiple masters. This could be helpful in situations where you need to replicate data from several PostgreSQL databases (OLTP) to a single PostgreSQL server for reporting and data warehousing.

One of the biggest advantages of logical over streaming replication is that logical replication allows us to replicate changes from an older version of PostgreSQL to a later version.

The following steps will show you how to stream replicated PostgreSQL data between masters and standby, as in the simplified "ASCII art":

    cluster_a_master
    |--> standby_a_1
    |--> standby_a_2
    |--> standby_a_3

## Steps to check your setup

### Start instances

To start one master and three standby instances, use the following command:

     $ docker-compose up --build --scale standby_a=3"

### View running statuses

To view the running statuses (health: starting, healhty), use the following command:

     $ docker ps

### Log in to DB

Log in to your database, using the following command with a temporary available port number. You should remove the port number within a production setup, and use a docker-swarm network for your internal connection.

     $ psql -h 127.0.0.1 -U postgres -p 5432

### Check result

Run the PostgreSQL commands below at the prompt, and check the result each time:

     SELECT * FROM pg_stat_replication;
     SELECT application_name, state, sync_priority, sync_state FROM pg_stat_replication;

### Testing

Create a table (in your master instance) and insert some data into it:

     CREATE TABLE test_replication (data varchar(100));
     INSERT INTO test_replication VALUES ('https://thecatapi.com/');
     INSERT INTO test_replication VALUES ('https://www.asciiart.eu/animals/cows');
     INSERT INTO test_replication VALUES ('pg_cluster replication test successful');

### Log in to container

Log in to your container using the following commands. But replace "2a5929305ca9" with the image ID you see when you enter `$ docker ps`. If you like to check the images without opening the ports, as in the first master instance within docker-compose.yml, you can simply get into a docker image ID e.g. via `exec -it image_id`.

     $ docker ps
     $ docker exec -it 2a5929305ca9 sh

Log in to the different instances, and check how fast databases, tables, and data is replicated. Check the data on the 'test_replication' table with the PostgreSQL query below.

Test in your ("read-only") standby what was replicated:

     SELECT * FROM test_replication;

Test the setup information of the standby or logical replicating master:

     SELECT * FROM pg_stat_replication;

### HSTORE

PostgreSQL supports the adding of extensions via SQL commands or shell scripts during the installation. By default, the repository builds are supported by PostgreSQL with HSTORE via the included SQL [hstore.sql](https://github.com/finnerds/postgresql/blob/master/standby/hstore.sql) command. Any .sql file and any executable .sh script copied into the initialisation [directory](https://github.com/finnerds/postgresql/blob/master/master/Dockerfile#L8) will be executed during the initialisation of the server - before the service is started.

### HEALTHCHECK

Both [stack.yml](https://github.com/finnerds/postgresql/blob/master/stack.yml) (for e.g. [Docker Swarm](https://docs.docker.com/engine/swarm/swarm-tutorial/) with [Portainer](https://www.portainer.io/products-services/portainer-community-edition/)) and [docker-compose.yml](https://github.com/finnerds/postgresql/blob/master/docker-compose.yml) include a [healthcheck](https://github.com/finnerds/postgresql/blob/master/docker-compose.yml#L15) for master and standby:

    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

## References

- [Chapter 31.1. Logical Replication - Publication (PostgreSQL documentation)](https://www.postgresql.org/docs/current/logical-replication-publication.html)
- [Streaming_Replication (PostgreSQL wiki)](https://wiki.postgresql.org/wiki/Streaming_Replication)
- [Replication Between PostgreSQL Versions Using Logical Replication](https://www.percona.com/blog/2019/04/04/replication-between-postgresql-versions-using-logical-replication/)
- [How to Setup a Logical Replication on PostgreSQL 10](http://yallalabs.com/linux/how-to-setup-a-logical-replication-on-postgresql-10/)
- [Setup a streaming replication with PostgreSQL 10](https://blog.raveland.org/post/postgresql_sr/)
- [Getting Started with PostgreSQL Streaming Replication](https://scalegrid.io/blog/getting-started-with-postgresql-streaming-replication/)
