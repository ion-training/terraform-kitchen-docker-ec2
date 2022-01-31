# terraform-kitchen-docker-ec2
Create an EC2 instance on AWS and run a test.

In this particular example, the test is to check that the system is running Ubuntu operating system.

Assumptions:
- Linux/MacOS is used
- Docker is installed
- AWSCLI is installed on the host and keys are added in ~/.aws/credentials
- system has ~/.ssh directory with id_rsa and id_rsa.pub (public and private key)

# How to use the code in this repository

Download this repository.
```
git clone https://github.com/ionhashicorp/kitchen-kitchen-docker-ec2.git
```

Change directory into the downloaded repo
```
cd terraform-kitchen-docker-ec2
```

Build the docker image based on Dockerfile with tag kitchen.
```
docker build -t kitchen .
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

Start the docker image and return bash prompt.
```
docker container run \
 -v ~/.aws/:/root/.aws \
 -v ${PWD}/tf_aws_cluster/:/root/tf_aws_cluster/ \
 -v ~/.ssh/:/root/.ssh/ -it kitchen bash
```

Directory structure from within the container.\
Notice that everything seen is the output from the tf_aws_cluster on the host (compare with above):
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

# Modify the variables in testing.tfvars (optional)
For example you cam modify the instance type to t2.micro.



# Create additional tests
More tests can be added under controls directory. \
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


# Sample output for verifying a test that succeeds
Notice the line "Command: `lsb_release -a`" and three lines bellow.
```
bash-5.1# bundle exec kitchen verify
-----> Starting Test Kitchen (v3.1.0)
-----> Setting up <default-ubuntu>...
       Finished setting up <default-ubuntu> (0m0.00s).
-----> Verifying <default-ubuntu>...
$$$$$$ Reading the Terraform input variables from the Kitchen instance state...
$$$$$$ Finished reading the Terraform input variables from the Kitchen instance state.
$$$$$$ Reading the Terraform output variables from the Kitchen instance state...
$$$$$$ Finished reading the Terraform output variables from the Kitchen instance state.
$$$$$$ Verifying the systems...
$$$$$$ Verifying the 'default' system...

Command: `lsb_release -a`
  stdout
    is expected to match /Ubuntu/

Finished in 0.29898 seconds (files took 9.22 seconds to load)
1 example, 0 failures

$$$$$$ Finished verifying the 'default' system.
$$$$$$ Finished verifying the systems.
       Finished verifying <default-ubuntu> (0m9.46s).
-----> Test Kitchen is finished. (0m10.06s)
bash-5.1# 
```


# Sample output converge
```
bash-5.1# bundle exec kitchen converge
-----> Starting Test Kitchen (v3.1.0)
-----> Creating <default-ubuntu>...
$$$$$$ Reading the Terraform client version...
       Terraform v1.0.9
       on linux_amd64
$$$$$$ Finished reading the Terraform client version.
$$$$$$ Verifying the Terraform client version is in the supported interval of >= 0.11.4, < 1.1.0...
$$$$$$ Finished verifying the Terraform client version.
$$$$$$ Initializing the Terraform working directory...
       
       Initializing the backend...
       
       Initializing provider plugins...
       - Finding latest version of hashicorp/random...
       - Finding latest version of hashicorp/aws...
       - Installing hashicorp/random v3.1.0...
       - Installed hashicorp/random v3.1.0 (signed by HashiCorp)
       - Installing hashicorp/aws v3.63.0...
       - Installed hashicorp/aws v3.63.0 (signed by HashiCorp)
       
       Terraform has created a lock file .terraform.lock.hcl to record the provider
       selections it made above. Include this file in your version control repository
       so that Terraform can guarantee to make the same selections by default when
       you run "terraform init" in the future.
       
       Terraform has been successfully initialized!
$$$$$$ Finished initializing the Terraform working directory.
$$$$$$ Creating the kitchen-terraform-default-ubuntu Terraform workspace...
       Created and switched to workspace "kitchen-terraform-default-ubuntu"!
       
       You're now on a new, empty workspace. Workspaces isolate their state,
       so if you run "terraform plan" Terraform will not see any existing state
       for this configuration.
$$$$$$ Finished creating the kitchen-terraform-default-ubuntu Terraform workspace.
       Finished creating <default-ubuntu> (0m7.36s).
-----> Converging <default-ubuntu>...
$$$$$$ Reading the Terraform client version...
       Terraform v1.0.9
       on linux_amd64
       + provider registry.terraform.io/hashicorp/aws v3.63.0
       + provider registry.terraform.io/hashicorp/random v3.1.0
$$$$$$ Finished reading the Terraform client version.
$$$$$$ Verifying the Terraform client version is in the supported interval of >= 0.11.4, < 1.1.0...
$$$$$$ Finished verifying the Terraform client version.
$$$$$$ Selecting the kitchen-terraform-default-ubuntu Terraform workspace...
$$$$$$ Finished selecting the kitchen-terraform-default-ubuntu Terraform workspace.
$$$$$$ Downloading the modules needed for the Terraform configuration...
$$$$$$ Finished downloading the modules needed for the Terraform configuration.
$$$$$$ Validating the Terraform configuration files...
       Success! The configuration is valid.
       
$$$$$$ Finished validating the Terraform configuration files.
$$$$$$ Building the infrastructure based on the Terraform configuration...
       
       Terraform used the selected providers to generate the following execution
       plan. Resource actions are indicated with the following symbols:
         + create
       
       Terraform will perform the following actions:
       
         # aws_instance.example will be created
         + resource "aws_instance" "example" {
             + ami                                  = "ami-fce3c696"
             + arn                                  = (known after apply)
             + associate_public_ip_address          = (known after apply)
             + availability_zone                    = (known after apply)
             + cpu_core_count                       = (known after apply)
             + cpu_threads_per_core                 = (known after apply)
             + disable_api_termination              = (known after apply)
             + ebs_optimized                        = (known after apply)
             + get_password_data                    = false
             + host_id                              = (known after apply)
             + id                                   = (known after apply)
             + instance_initiated_shutdown_behavior = (known after apply)
             + instance_state                       = (known after apply)
             + instance_type                        = "m3.medium"
             + ipv6_address_count                   = (known after apply)
             + ipv6_addresses                       = (known after apply)
             + key_name                             = (known after apply)
             + monitoring                           = (known after apply)
             + outpost_arn                          = (known after apply)
             + password_data                        = (known after apply)
             + placement_group                      = (known after apply)
             + placement_partition_number           = (known after apply)
             + primary_network_interface_id         = (known after apply)
             + private_dns                          = (known after apply)
             + private_ip                           = (known after apply)
             + public_dns                           = (known after apply)
             + public_ip                            = (known after apply)
             + secondary_private_ips                = (known after apply)
             + security_groups                      = (known after apply)
             + source_dest_check                    = true
             + subnet_id                            = (known after apply)
             + tags                                 = (known after apply)
             + tags_all                             = (known after apply)
             + tenancy                              = (known after apply)
             + user_data                            = (known after apply)
             + user_data_base64                     = (known after apply)
             + vpc_security_group_ids               = (known after apply)
       
             + capacity_reservation_specification {
          + capacity_reservation_preference = (known after apply)
       
          + capacity_reservation_target {
              + capacity_reservation_id = (known after apply)
            }
        }
       
             + ebs_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + snapshot_id           = (known after apply)
          + tags                  = (known after apply)
          + throughput            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }
       
             + enclave_options {
          + enabled = (known after apply)
        }
       
             + ephemeral_block_device {
          + device_name  = (known after apply)
          + no_device    = (known after apply)
          + virtual_name = (known after apply)
        }
       
             + metadata_options {
          + http_endpoint               = (known after apply)
          + http_put_response_hop_limit = (known after apply)
          + http_tokens                 = (known after apply)
        }
       
             + network_interface {
          + delete_on_termination = (known after apply)
          + device_index          = (known after apply)
          + network_interface_id  = (known after apply)
        }
       
             + root_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + tags                  = (known after apply)
          + throughput            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }
           }
       
         # aws_key_pair.kitchen_pub_key will be created
         + resource "aws_key_pair" "kitchen_pub_key" {
             + arn         = (known after apply)
             + fingerprint = (known after apply)
             + id          = (known after apply)
             + key_name    = (known after apply)
             + key_pair_id = (known after apply)
             + public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCifqoRxTPwJP+bWgXEFnuE7oVz4C6yiRaqtvw+oDnpfwUPAdn088GArv4HfTKKU2OCziwx8fc6dyhKQrymttooriupmZdz6nSlWe1pfmvtmf2C8OS62qluCmKxHHbTim0mmVK2sv1WVO7AvNcNX1S9yJyBP8GJE2d+JbueYM8AeysRl6Q+14y54XCTid0QrxUVZPVeC04523PTFHw1UILi7G/ehufpHOffqvI/gK3wVC9tzRCzrbvdCSyVGse/ynAwDKIxLOkkABU9pkXE4eKB4HSSD4fx+C80SlPldMCKhkRDBDXOrxnVLGd9P0vkc5D5ON9z0rWpsaa08/OM9xU2p39+/NLbg5fEeGoURxyPhHdMJ3A4Cff1Se5ESAIiIwkBcxjCLsBMJ8L9c4rLF6csSFM6eacByJZV6WHnZIoPwJzjT7vkWaL2rFBVlS7kNgeg9NL/Tu3KUIRT/NuvBjSEryDRZvGQuIxGMsy6YmVzCzXSxBJwdiAPz7FgKZN+986XvhAVWXGeCjml5Q3O9l0ci9409PgLopUmnSXJrXijK4Wfr5EyHj090EXxYv+meF6YYn0uM9Tc51fmkBIFCzSbVZDiTQI0a5YZSurXs2KIhksYh+f+aLF8rozq2JbJutZrPGY6ZW1P8z4un4r0TVAxZa5/PupWCk2WA1JJ+SO+OQ== ion@ion-C02G34GHMD6R"
             + tags_all    = (known after apply)
           }
       
         # aws_security_group.allow_ssh will be created
         + resource "aws_security_group" "allow_ssh" {
             + arn                    = (known after apply)
             + description            = "Allow SSH inbound traffic"
             + egress                 = (known after apply)
             + id                     = (known after apply)
             + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 22
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 22
            },
        ]
             + name                   = (known after apply)
             + name_prefix            = (known after apply)
             + owner_id               = (known after apply)
             + revoke_rules_on_delete = false
             + tags_all               = (known after apply)
             + vpc_id                 = (known after apply)
           }
       
         # random_pet.suffix will be created
         + resource "random_pet" "suffix" {
             + id        = (known after apply)
             + length    = 1
             + separator = "-"
           }
       
       Plan: 4 to add, 0 to change, 0 to destroy.
       
       Changes to Outputs:
         + public_dns = (known after apply)
       random_pet.suffix: Creating...
       random_pet.suffix: Creation complete after 0s [id=shrew]
       aws_key_pair.kitchen_pub_key: Creating...
       aws_security_group.allow_ssh: Creating...
       aws_key_pair.kitchen_pub_key: Creation complete after 1s [id=kitchen-pub-key_shrew]
       aws_security_group.allow_ssh: Creation complete after 5s [id=sg-0a5b7e032d95bf504]
       aws_instance.example: Creating...
       aws_instance.example: Still creating... [10s elapsed]
       aws_instance.example: Still creating... [20s elapsed]
       aws_instance.example: Creation complete after 27s [id=i-0d76f5dc297e86133]
       
       Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
       
       Outputs:
       
       public_dns = "ec2-54-211-211-61.compute-1.amazonaws.com"
$$$$$$ Finished building the infrastructure based on the Terraform configuration.
$$$$$$ Reading the output variables from the Terraform state...
$$$$$$ Finished reading the output variables from the Terraform state.
$$$$$$ Parsing the Terraform output variables as JSON...
$$$$$$ Finished parsing the Terraform output variables as JSON.
$$$$$$ Writing the output variables to the Kitchen instance state...
$$$$$$ Finished writing the output variables to the Kitchen instance state.
$$$$$$ Writing the input variables to the Kitchen instance state...
$$$$$$ Finished writing the input variables to the Kitchen instance state.
       Finished converging <default-ubuntu> (0m40.40s).
-----> Test Kitchen is finished. (0m48.40s)
bash-5.1# 
```

# Sample output destroy
```
bash-5.1# bundle exec kitchen destroy
-----> Starting Test Kitchen (v3.1.0)
-----> Destroying <default-ubuntu>...
$$$$$$ Reading the Terraform client version...
       Terraform v1.0.9
       on linux_amd64
       + provider registry.terraform.io/hashicorp/aws v3.63.0
       + provider registry.terraform.io/hashicorp/random v3.1.0
$$$$$$ Finished reading the Terraform client version.
$$$$$$ Verifying the Terraform client version is in the supported interval of >= 0.11.4, < 1.1.0...
$$$$$$ Finished verifying the Terraform client version.
$$$$$$ Initializing the Terraform working directory...
       
       Initializing the backend...
       
       Initializing provider plugins...
       - Reusing previous version of hashicorp/random from the dependency lock file
       - Reusing previous version of hashicorp/aws from the dependency lock file
       - Using previously-installed hashicorp/aws v3.63.0
       - Using previously-installed hashicorp/random v3.1.0
       
       Terraform has been successfully initialized!
$$$$$$ Finished initializing the Terraform working directory.
$$$$$$ Selecting the kitchen-terraform-default-ubuntu Terraform workspace...
$$$$$$ Finished selecting the kitchen-terraform-default-ubuntu Terraform workspace.
$$$$$$ Destroying the Terraform-managed infrastructure...
       random_pet.suffix: Refreshing state... [id=shrew]
       aws_security_group.allow_ssh: Refreshing state... [id=sg-0a5b7e032d95bf504]
       aws_key_pair.kitchen_pub_key: Refreshing state... [id=kitchen-pub-key_shrew]
       aws_instance.example: Refreshing state... [id=i-0d76f5dc297e86133]
       
       Note: Objects have changed outside of Terraform
       
       Terraform detected the following changes made outside of Terraform since the
       last "terraform apply":
       
         # aws_key_pair.kitchen_pub_key has been changed
         ~ resource "aws_key_pair" "kitchen_pub_key" {
        id          = "kitchen-pub-key_shrew"
             + tags        = {}
        # (6 unchanged attributes hidden)
           }
         # aws_security_group.allow_ssh has been changed
         ~ resource "aws_security_group" "allow_ssh" {
        id                     = "sg-0a5b7e032d95bf504"
        name                   = "allow_ssh_shrew"
             + tags                   = {}
        # (8 unchanged attributes hidden)
           }
       
       Unless you have made equivalent changes to your configuration, or ignored the
       relevant attributes using ignore_changes, the following plan may include
       actions to undo or respond to these changes.
       
       ─────────────────────────────────────────────────────────────────────────────
       
       Terraform used the selected providers to generate the following execution
       plan. Resource actions are indicated with the following symbols:
         - destroy
       
       Terraform will perform the following actions:
       
         # aws_instance.example will be destroyed
         - resource "aws_instance" "example" {
             - ami                                  = "ami-fce3c696" -> null
             - arn                                  = "arn:aws:ec2:us-east-1:267023797923:instance/i-0d76f5dc297e86133" -> null
             - associate_public_ip_address          = true -> null
             - availability_zone                    = "us-east-1d" -> null
             - cpu_core_count                       = 1 -> null
             - cpu_threads_per_core                 = 1 -> null
             - disable_api_termination              = false -> null
             - ebs_optimized                        = false -> null
             - get_password_data                    = false -> null
             - hibernation                          = false -> null
             - id                                   = "i-0d76f5dc297e86133" -> null
             - instance_initiated_shutdown_behavior = "stop" -> null
             - instance_state                       = "running" -> null
             - instance_type                        = "m3.medium" -> null
             - ipv6_address_count                   = 0 -> null
             - ipv6_addresses                       = [] -> null
             - key_name                             = "kitchen-pub-key_shrew" -> null
             - monitoring                           = false -> null
             - primary_network_interface_id         = "eni-0b8e7fcf5d185ee07" -> null
             - private_dns                          = "ip-172-31-92-37.ec2.internal" -> null
             - private_ip                           = "172.31.92.37" -> null
             - public_dns                           = "ec2-54-211-211-61.compute-1.amazonaws.com" -> null
             - public_ip                            = "54.211.211.61" -> null
             - secondary_private_ips                = [] -> null
             - security_groups                      = [
          - "allow_ssh_shrew",
        ] -> null
             - source_dest_check                    = true -> null
             - subnet_id                            = "subnet-de78b1ff" -> null
             - tags                                 = {
          - "Name" = "kitchen-instance_shrew"
        } -> null
             - tags_all                             = {
          - "Name" = "kitchen-instance_shrew"
        } -> null
             - tenancy                              = "default" -> null
             - vpc_security_group_ids               = [
          - "sg-0a5b7e032d95bf504",
        ] -> null
       
             - capacity_reservation_specification {
          - capacity_reservation_preference = "open" -> null
        }
       
             - enclave_options {
          - enabled = false -> null
        }
       
             - metadata_options {
          - http_endpoint               = "enabled" -> null
          - http_put_response_hop_limit = 1 -> null
          - http_tokens                 = "optional" -> null
        }
       
             - root_block_device {
          - delete_on_termination = true -> null
          - device_name           = "/dev/sda1" -> null
          - encrypted             = false -> null
          - iops                  = 100 -> null
          - tags                  = {} -> null
          - throughput            = 0 -> null
          - volume_id             = "vol-032995304d93d0dbf" -> null
          - volume_size           = 8 -> null
          - volume_type           = "gp2" -> null
        }
           }
       
         # aws_key_pair.kitchen_pub_key will be destroyed
         - resource "aws_key_pair" "kitchen_pub_key" {
             - arn         = "arn:aws:ec2:us-east-1:267023797923:key-pair/kitchen-pub-key_shrew" -> null
             - fingerprint = "c9:20:97:25:08:4b:fe:00:6c:ce:5a:ff:65:7c:76:90" -> null
             - id          = "kitchen-pub-key_shrew" -> null
             - key_name    = "kitchen-pub-key_shrew" -> null
             - key_pair_id = "key-002d20b77c796da4d" -> null
             - public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCifqoRxTPwJP+bWgXEFnuE7oVz4C6yiRaqtvw+oDnpfwUPAdn088GArv4HfTKKU2OCziwx8fc6dyhKQrymttooriupmZdz6nSlWe1pfmvtmf2C8OS62qluCmKxHHbTim0mmVK2sv1WVO7AvNcNX1S9yJyBP8GJE2d+JbueYM8AeysRl6Q+14y54XCTid0QrxUVZPVeC04523PTFHw1UILi7G/ehufpHOffqvI/gK3wVC9tzRCzrbvdCSyVGse/ynAwDKIxLOkkABU9pkXE4eKB4HSSD4fx+C80SlPldMCKhkRDBDXOrxnVLGd9P0vkc5D5ON9z0rWpsaa08/OM9xU2p39+/NLbg5fEeGoURxyPhHdMJ3A4Cff1Se5ESAIiIwkBcxjCLsBMJ8L9c4rLF6csSFM6eacByJZV6WHnZIoPwJzjT7vkWaL2rFBVlS7kNgeg9NL/Tu3KUIRT/NuvBjSEryDRZvGQuIxGMsy6YmVzCzXSxBJwdiAPz7FgKZN+986XvhAVWXGeCjml5Q3O9l0ci9409PgLopUmnSXJrXijK4Wfr5EyHj090EXxYv+meF6YYn0uM9Tc51fmkBIFCzSbVZDiTQI0a5YZSurXs2KIhksYh+f+aLF8rozq2JbJutZrPGY6ZW1P8z4un4r0TVAxZa5/PupWCk2WA1JJ+SO+OQ== ion@ion-C02G34GHMD6R" -> null
             - tags        = {} -> null
             - tags_all    = {} -> null
           }
       
         # aws_security_group.allow_ssh will be destroyed
         - resource "aws_security_group" "allow_ssh" {
             - arn                    = "arn:aws:ec2:us-east-1:267023797923:security-group/sg-0a5b7e032d95bf504" -> null
             - description            = "Allow SSH inbound traffic" -> null
             - egress                 = [] -> null
             - id                     = "sg-0a5b7e032d95bf504" -> null
             - ingress                = [
          - {
              - cidr_blocks      = [
                  - "0.0.0.0/0",
                ]
              - description      = ""
              - from_port        = 22
              - ipv6_cidr_blocks = []
              - prefix_list_ids  = []
              - protocol         = "tcp"
              - security_groups  = []
              - self             = false
              - to_port          = 22
            },
        ] -> null
             - name                   = "allow_ssh_shrew" -> null
             - owner_id               = "267023797923" -> null
             - revoke_rules_on_delete = false -> null
             - tags                   = {} -> null
             - tags_all               = {} -> null
             - vpc_id                 = "vpc-271a045d" -> null
           }
       
         # random_pet.suffix will be destroyed
         - resource "random_pet" "suffix" {
             - id        = "shrew" -> null
             - length    = 1 -> null
             - separator = "-" -> null
           }
       
       Plan: 0 to add, 0 to change, 4 to destroy.
       
       Changes to Outputs:
         - public_dns = "ec2-54-211-211-61.compute-1.amazonaws.com" -> null
       aws_instance.example: Destroying... [id=i-0d76f5dc297e86133]
       aws_instance.example: Still destroying... [id=i-0d76f5dc297e86133, 10s elapsed]
       aws_instance.example: Still destroying... [id=i-0d76f5dc297e86133, 20s elapsed]
       aws_instance.example: Still destroying... [id=i-0d76f5dc297e86133, 30s elapsed]
       aws_instance.example: Destruction complete after 32s
       aws_key_pair.kitchen_pub_key: Destroying... [id=kitchen-pub-key_shrew]
       aws_security_group.allow_ssh: Destroying... [id=sg-0a5b7e032d95bf504]
       aws_key_pair.kitchen_pub_key: Destruction complete after 1s
       aws_security_group.allow_ssh: Destruction complete after 2s
       random_pet.suffix: Destroying... [id=shrew]
       random_pet.suffix: Destruction complete after 0s
       
       Destroy complete! Resources: 4 destroyed.
$$$$$$ Finished destroying the Terraform-managed infrastructure.
$$$$$$ Selecting the default Terraform workspace...
       Switched to workspace "default".
$$$$$$ Finished selecting the default Terraform workspace.
$$$$$$ Deleting the kitchen-terraform-default-ubuntu Terraform workspace...
       Deleted workspace "kitchen-terraform-default-ubuntu"!
$$$$$$ Finished deleting the kitchen-terraform-default-ubuntu Terraform workspace.
       Finished destroying <default-ubuntu> (0m46.70s).
-----> Test Kitchen is finished. (0m47.31s)
bash-5.1# 
```
