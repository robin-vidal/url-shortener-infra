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
TF_VAR_db_password=<PASSWORD> terraform apply
```

## GitHub Actions secrets

Required in `url-shortener-infra`:

| Secret | Description |
|--------|-------------|
| `AWS_ACCESS_KEY_ID` | AWS Academy credentials |
| `AWS_SECRET_ACCESS_KEY` | AWS Academy credentials |
| `AWS_SESSION_TOKEN` | AWS Academy session token |
| `DB_PASSWORD` | Password for the RDS Postgres instance |
| `SSH_PRIVATE_KEY` | Contents of `url-shortener-key.pem` |

Required in `url-shortener-backend` and `url-shortener-frontend`:

| Secret | Description |
|--------|-------------|
| `AWS_ACCESS_KEY_ID` | AWS Academy credentials |
| `AWS_SECRET_ACCESS_KEY` | AWS Academy credentials |
| `AWS_SESSION_TOKEN` | AWS Academy session token |

## AWS Academy

Credentials expire every 4h. Set the three AWS secrets in each GitHub repo.
