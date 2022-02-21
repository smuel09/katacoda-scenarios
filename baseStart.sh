# Install Terraform and init config

# Installs Terraform 0.13.5
curl -O https://releases.hashicorp.com/terraform/terraform_0.15.1/terraform_0.15.1_linux_amd64.zip
unzip terraform_0.13.5_linux_amd64.zip -d /usr/local/bin/

# Installs awscli
apt-get install awscli -y

# Clone GitHub repo
git clone -b localstack https://github.com/hashicorp/learn-terraform-modules
cd ~/learn-terraform-modules

pip3 install localstack
localstack start &>localstack-output.log &


echo 'version: 3.8

services:
    localstack:
        container_name: "localstack_main"
        image: localstack/localstack:latest
        environment: 
            - SERVICES=dynamodb,lambda,kinesis
            - LAMBDA_EXECUTOR=docker_reuse
            - DOCKER_HOST=unix:///var/run/docker.sock
            - DEFAULT_REGION=ap-southeast-2
            - DEBUG=1
            - DATA_DIR=/tmp/localstack/data
            - PORT_WEB_UI=8080
            - LAMBDA_DOCKER_NETWORK=localstack-tutorial
            - KINESIS_PROVIDER=kinesalite
        ports:
            - "53:53"
            - "53:53/udp"
            - "443:443"
            - "4566:4566"
            - "4571:4571"
            - "8080:8080"
        volumes:
            - /var/run/docker.sock:/var/run/docker.sock
            - localstack_data:/tmp/localstack/data
        networks:
            default:

volumes:
    localstack_data:
networks:
    default:
        external:
            name: localstack-tutorial
' > docker-compose.yml

# Run Docker Compose up (daemon)
docker-compose up -d

# Install localstack (don't run dockerfile on katacoda)

# Prevent `yes` command from accidentally being run
alias yes=""

# Adds mock AWS Credentials to environment variables
export AWS_ACCESS_KEY_ID=fake
export AWS_SECRET_ACCESS_KEY=fake

# Include current dir in prompt
PS1='\W$ '

# Download assets for S3 bucket
mkdir assets
curl -o assets/index.html https://raw.githubusercontent.com/hashicorp/learn-terraform-modules/master/modules/aws-s3-static-website-bucket/www/index.html
curl -o assets/error.html https://raw.githubusercontent.com/hashicorp/learn-terraform-modules/master/modules/aws-s3-static-website-bucket/www/error.html

clear

echo "Ready!"