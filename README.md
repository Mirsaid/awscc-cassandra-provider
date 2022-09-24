AWS Cloud Control Provider Usage

Which services I used?:

AWS Cloud Control provider, aws keyspace, random_pet provider, aws provider, docker for loading data to cassandra table

Loading the sample data from the data/ directory into newly provisioned Cassandra Table:

I will use docker image pre-configured by Amazon with cqlsh and an authentication plugin.
building docker:
docker build --tag amazon/keyspaces-toolkit --build-arg CLI_VERSION=latest \
         https://github.com/aws-samples/amazon-keyspaces-toolkit.git

launch docker:
docker run -ti --rm --mount type=bind,src=$(pwd)/data,dst=/data \
         --env-file ./aws_auth_env \
         --env AWS_DEFAULT_REGION="$(terraform output -raw aws_region)" \
         --entrypoint cqlsh-expansion amazon/keyspaces-toolkit \
                      cassandra.$(terraform output -raw aws_region).amazonaws.com \
                      -k $(terraform output -raw keyspace_name) \
                      --ssl --auth-provider "SigV4AuthProvider"

copy data from csv file to cassandra table:

CONSISTENCY LOCAL_QUORUM; COPY users (id, first_name, last_name, email) FROM '/data/users.csv' WITH HEADER = TRUE;


