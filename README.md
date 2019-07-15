# Postgresql streaming and logical replication

The following steps show you how to stream replicate and logicly replicate postgresql data between masters and slaves, as how in the simplified "ascii-art"

    clustera_master --> clustera_slave1
		            |-> clustera_slave2
		            |
    clusterb_master --> clusterb_slave

Cluster A with streaming replication "-", and cluster B with logical replication "|".

## Steps to check your setup

### To start

     $ docker-compose up

#### To check 

     $ docker ps

### To Login 

With a temp available portnumber, you should remove it within a production setup, and use a docker-swarm network for your internal connection:

     $ psql -h 127.0.0.1 -U postgres -p 5432

### To check 

Run the "Postgres SQL" commands below at the prompt, and check each time the result:

     SELECT * FROM pg_stat_replication;
     SELECT application_name, state, sync_priority, sync_state FROM pg_stat_replication;

### To test

Create a table and insert some data into it

     CREATE TABLE test_replication (data varchar(100));
     INSERT INTO test_replication VALUES ('https://thecatapi.com/');
     INSERT INTO test_replication VALUES ('https://www.asciiart.eu/animals/cows');
     INSERT INTO test_replication VALUES ('pg_cluster replication test successful');

### AddOn

If you like to check the images without opening the ports, as in the first master instance within docker-compose.yml you can do get into an docker image id via e.g. "exec -it image_id"

     $ docker ps
     $ docker exec -it  2a5929305ca9 sh

but replace "2a5929305ca9" with the image id you see when you enter "$ docker ps".

Login to the different instances, and check how fast databases, tables, and data is replicated. Check data on the 'test_replication' table with postgres query below.

Test what was replicated

     SELECT * FROM test_replication;

Test the setup within the slave or logical replicating master

     SELECT * FROM pg_stat_replication;