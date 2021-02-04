

Open `main.tf`, uncomment the `backend` configuration, and fill in the name of your S3 bucket, DynamoDB table, and
the path to use for the Terraform state file.

Deploy the code:

```
terraform init
terraform apply
```

Clean up when you're done:

```
terraform destroy
```
