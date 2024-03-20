tf-init:
	terraform init

tf-fmt-validate:
	terraform fmt
	terraform validate

tf-plan:
	terraform plan -out tf.plan
	terraform show -no-color tf.plan > tfplan.txt

tf-create:
	terraform apply

build:
	make tf-init
	make tf-fmt-validate
	make tf-create

tf-clean:
	rm -rf terraform.tfstate terraform.tfstate.backup .terraform.lock.hcl .terraform
