terraform {
    # backend "local" {
    #     #path = "${path.module}/../../terraform.tfstate"
    # }
  required_providers {
    vagrant = {
      source = "bmatcuk/vagrant"
    }
    ansible = {
      source = "ansible/ansible"
    }
  }
}