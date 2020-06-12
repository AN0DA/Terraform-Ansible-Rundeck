 #!/bin/bash
 set -euxo pipefail

touch rundeck.ini
echo "[rundeck]" | tee rundeck.ini;
# 1 - ${aws_instance.rundeck_test.public_ip} / 2 - ${var.ansible_user} / 3 - ${var.private_key}
echo "$1 ansible_public_ip=$1 ansible_user=$2 ansible_ssh_private_key_file=$3" | tee -a rundeck.ini;

export ANSIBLE_HOST_KEY_CHECKING=False;

ansible-playbook -u $2 --private-key $3 -i ./rundeck.ini ./playbooks/install_rundeck.yml