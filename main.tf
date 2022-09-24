terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }

    awscc = {
	source = "hashicorp/awscc"
	version = "~> 0.1.0"
	
	}	
    random = {
	source = "hashicorp/random"
	version = "~> 3.1.0"
	}
	
  }
}

provider "aws" {
  region = var.aws_region
}
provider "awscc" {
  region = var.aws_region
}

provide "random" {}

resource "aws_kms_key" "terraform" {
  description = "Example key for Cassandra table"
}

resource "random_pet" "keyspace" {
	length = 4
	separator = "_"
}

resource "awscc_cassandra_keyspace" "cassandra-ks"{
	keyspace_name = random_pet.keyspace.id
} 

resource "awscc_cassandra_table" "users"{
	keyspace_name = awscc_cassandra_keyspace.cassandra-ks.keypace_name
	table_name = "users"
	 partition_key_columns = [
    {
      column_name : "id"
      column_type : "int"
    }
  ]
      regular_columns = [
    {
      column_name : "first_name"
      column_type : "text"
    },
    {
      column_name : "last_name"
      column_type : "text"
    },
    {
      column_name : "email"
      column_type : "text"
    }
  ]	
  
    encryption_specification = {

	encryption_type : "AWS_OWNED_KMS_KEY"
	kms_key_identifier : aws_kms_key.terraform.key_id
}

}




