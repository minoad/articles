terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "2.5.1"
    }
  }
}

resource "local_file" "foo" {
            content  = "foo!"
            filename = "${path.module}/bar/foo.bar"
        }