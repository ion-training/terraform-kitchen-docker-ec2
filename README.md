# kitchen-terraform-docker-ec2
Create an EC2 instance on AWS and run tests. \
Details can be found on this [link](https://newcontext-oss.github.io/kitchen-terraform/tutorials/amazon_provider_ec2.html).

In this particular example, the tests is to check that the system is running Ubuntu operating system.

Assumptions:
- Linux/MacOS is used
- Docker is installed
- AWSCLI is installed on the host and keys are added in ~/.aws/credentials
- system has ~/.ssh directory with id_rsa and id_rsa.pub (public and private key)

# How to use the code in this repository

Download this repository.
```
git clone https://github.com/ionhashicorp/kitchen-terraform-docker-ec2.git
```

Change directory into the downloaded repo
```
cd kitchen-terraform-docker-ec2
```

Directory structure of this repo.
```
$ tree
├── Dockerfile
├── LICENSE
├── README.md
└── tf_aws_cluster
    ├── main.tf
    ├── output.tf
    ├── test
    │   └── integration
    │       └── default
    │           ├── controls
    │           │   └── operating_system_spec.rb
    │           └── inspec.yml
    └── variables.tf
$
```


Build the docker image based on Dockerfile with tag kitchen.
```
docker build -t kitchen .
```

Start the docker image and return bash prompt.
```
docker container run \
 -v ~/.aws/:/root/.aws \
 -v ${PWD}/tf_aws_cluster/:/root/tf_aws_cluster/ \
 -v ~/.ssh/:/root/.ssh/ -it kitchen bash
```

Directory structure from within the container.
Notice you see everything from the tf_aws_cluster on the host (compare with above):
```
# tree
.
├── main.tf
├── output.tf
├── test
│   └── integration
│       └── default
│           ├── controls
│           │   └── operating_system_spec.rb
│           └── inspec.yml
└── variables.tf
#
```

More tests can be added under controls directory.
Feel free to copy and modify the operating_system_spec.rb.

# How to run tests
_Make sure bellow commands are run within the container._
Prepare the infrastructure (create the EC2, VPC, SG)
```
bundle exec kitchen converge
```

Run the test.
```
bundle exec kitchen verify
```

Destroy the infrastructure (kill the EC2, VPC, SG)
```
bundle exec kitchen destroy
```


# Sample output
