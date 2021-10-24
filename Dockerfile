FROM ruby:2.7.4-alpine
RUN apk update && apk add --no-cache build-base curl zip unzip openssh tree bash

# Install aws cli and prepare ~/.aws #
# https://stackoverflow.com/questions/61918972/how-to-install-aws-cli-on-alpine
RUN apk add --no-cache  python3  py3-pip \
    && pip3 install --upgrade pip \
    && pip3 install --no-cache-dir awscli \
    && rm -rf /var/cache/apk/*

# PREPARE KITCHEN-TERRAFORM package #
# https://newcontext-oss.github.io/kitchen-terraform/tutorials/amazon_provider_ec2.html #
RUN echo "ruby '2.7.4'" > Gemfile
RUN echo "source 'https://rubygems.org/' do" >> Gemfile
RUN echo "  gem 'kitchen-terraform', '~> 6.0'" >> Gemfile
RUN echo "end" >> Gemfile
RUN bundle install --quiet


# ENVIRONMENT VARIABLES #
# #######################
ENV TERRAFORM_VERSION="1.0.9"
ENV ARCH="amd64"

# # TERRAFORM DOWNLOAD #
RUN curl --silent --remote-name https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip

# # TERRAFORM DOWNLOAD INSTALL #
RUN unzip terraform_1.0.9_linux_amd64.zip
RUN mv terraform /usr/local/bin/
RUN touch ~/.bashrc
RUN terraform -install-autocomplete

WORKDIR /root/tf_aws_cluster

CMD ['bash']