# Terraform-Ansible-Rundeck

## About

Script creating AWS VM using Terraform, then installing Rundeck with Ansible

## Current state

- [x] Create VM
- [x] Make ssh connection
- [x] Install Java (Rundeck dependency)
- [ ] Install Rundeck
- [ ] Configure Rundeck


## Auto variable filling

Create file `*.auto.tfvars` with pattern:
> Default values can be seen in [var.tf](var.tf).

```tf
aws_region = ""
aws_access_key = ""
aws_secret_key = ""
```
