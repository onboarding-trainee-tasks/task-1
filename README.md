# Onboarding task 1 - AWS infrastructure

This repository covers the implementation of Onboarding Task 1. The completed version is on the `onb-1-create-infrastructure` branch.

## Implementation Features

- SSH key is generated on-premises
- For SSH access to internal hosts (LLM) a bastion host with ProxyJump is used
- The bastion installs the PostgreSQL client, downloads `db_init.sql` from S3 and runs it against RDS. The private instances install and start Ollama.

## External dependencies (things created outside Terraform)

These resources/files must exist before `terraform init` or `terraform apply`:

1. **AWS credentials**
    
    Configure IAM account for AWS CLI (Terraform reads credentials from CLI) - not required, but used in project with `AdministratorAccess` permissions policy.

    Another IAM dependencies are covered by Terraform, no external actions needed. 

2. **S3 bucket for Terraform state**

   - Bucket: `tf-backend-onboarding-task`
   - Region: `eu-central-1`
   - State key: `infra/state`

3. **RDS secret in AWS Secrets Manager**

   It should contain:

   ```json
   {
     "db_username": "...",
     "db_password": "..."
   }
   ```

   Replace the secret ARN in `variables.tf`

4. **S3 bucket and SQL initialization file**

   Create the `init-sql-script` bucket and upload the SQL file as
   `s3://init-sql-script/db_init.sql`. SQL file is stored in this
   repository.

5. **Local SSH key**

   Terraform uploads the public key to AWS. The default path is Windows-specific:
   `C:\Onboarding\.ssh\terraform-ssh-key.pub`. Override `ssh_key_path` if the key is stored somewhere else, and keep the matching private key locally.

## How to run

```bash
git clone https://github.com/onboarding-trainee-tasks/task-1.git
cd task-1
git switch onb-1-create-infrastructure

terraform init
terraform fmt
terraform validate
terraform apply
```

Use a narrow CIDR such as your public IP for SSH access. After apply, get the
bastion IP with `terraform output ssh_command`. The output contains the ssh command with SSH key path.