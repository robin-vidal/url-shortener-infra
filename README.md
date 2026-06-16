# url-shortener-infra

Terraform, Ansible and GitHub Actions for the URL Shortener project (ING2 DevOps + AWS).

## Setup (once)

```bash
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
aws s3 mb s3://url-shortener-tfstate-${ACCOUNT_ID} --region us-east-1
aws ec2 create-key-pair --key-name url-shortener-key --query KeyMaterial --output text > url-shortener-key.pem
chmod 400 url-shortener-key.pem
```

## Deploy

```bash
cd terraform/
terraform init
terraform apply -var="db_password=<PASSWORD>"
```

## AWS Academy

Credentials expire every 4h. Update them in `~/.aws/credentials` and in GitHub Actions secrets.
