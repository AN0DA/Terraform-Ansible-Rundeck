# Terraform-Ansible-Rundeck

## About

Script creating AWS VM using Terraform, then installing Rundeck with Ansible.

### Result

When accessing the instance's IP address via a web browser Rundeck login screen will load. Default credentials are `user: admin` and `password: admin`

## Current state

- [x] Create VM
- [x] Make ssh connection
- [x] Install dependencies
- [x] Install Rundeck
- [x] Configure Rundeck
- [x] Configure proxy server


## Auto variable filling

Create `*.auto.tfvars` file with pattern:
> Default values can be seen in [var.tf](var.tf)

```hcl
aws_region = ""
aws_access_key = ""
aws_secret_key = ""

# Path to file is suggested here
public_key = ""
private_key = ""

ansible_user = ""
```
