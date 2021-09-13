apply:
	terraform apply -auto-approve -var-file=variables.tfvars

destroy:
	terraform apply -destroy -auto-approve -var-file=variables.tfvars

replace: destroy apply;

.PHONY: apply destroy