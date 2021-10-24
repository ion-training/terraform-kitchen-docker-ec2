# kitchen-terraform-docker-ec2
Create an EC2 instance on AWS and run tests. Details can be found on this [link](https://newcontext-oss.github.io/kitchen-terraform/tutorials/amazon_provider_ec2.html).

Assumptions:
- Linux/MacOS is used
- Docker is installed
- AWSCLI is installed on your host
- system has ~/.ssh directory with id_rsa and id_rsa.pub (public and private key)

# How to use the code in this repository

Download this repository and change directory into it
```
git clone https://github.com/ionhashicorp/kitchen-terraform-docker-ec2.git && cd kitchen-terraform-docker-ec2
```

Build the docker image based on Dockerfile with tag kitchen.
```
docker build -t kitchen
```

Start the docker image and return bash prompt.
```
docker container run -v ~/.aws/:/root/.aws  -v ${PWD}/tf_aws_cluster/:/root/tf_aws_cluster/ -v ~/.ssh/:/root/.ssh/ -it kitchen bash
```

