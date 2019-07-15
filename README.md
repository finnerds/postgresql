# Postgresql streaming and logical replication

    clustera_master --> clustera_slave1
		    |-> clustera_slave2
		    |
    clusterb_master --> clusterb_slave

Cluster A with streaming replication "-", and cluster B with logical replication "|".

To start:

     $ docker-compose up

To Login:
:
     $ psql -U postgres -H 127.0.0.1

To check the status run psql commands below:

     $ psql -c "select application_name, state, sync_priority, sync_state from pg_stat_replication;"
     $ psql -x -c "select * from pg_stat_replication;" 

To test the replication in the different instances (via port or via local login):

     $ psql -U postgres -H 127.0.0.1
    
and enter the following SQL commands
 
     CREATE TABLE test_replication (data varchar(100));
     INSERT INTO test_replication VALUES ('https://thecatapi.com/);
     INSERT INTO test_replication VALUES ('https://www.asciiart.eu/animals/cows);
     INSERT INTO test_replication VALUES ('pg_cluster replication test successful');

Login to the different instances, and check how fast databases, tables, and data is replicated. Check data on the 'test_replication' table with postgres query below.

     $ select * from test_replication;

If you like to check the images without opening the ports as its show in docker-compose.yml you can do it with the docker image id you see with

     $ docker ps
     $ docker exec -it  2a5929305ca9 sh

but replace 2a5929305ca9 with the image id you see with "$ docker ps".
