 #!/bin/sh
 
touch java.ini
echo "[java]" | tee -a java.ini;
# 1 - ${aws_instance.rundesk_test.public_ip} / 2 - ${var.ansible_user} / 3 - ${var.private_key}
echo "$1 ansible_user=$2 ansible_ssh_private_key_file=$3" | tee -a java.ini;
      export ANSIBLE_HOST_KEY_CHECKING=False;
	  ansible-playbook -u $2 --private-key $3 -i ./java.ini ./install_java.yaml