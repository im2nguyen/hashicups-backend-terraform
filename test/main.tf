terraform {
  cloud {
    hostname = "app.terraform.io"
    organization = "hashicorp-learn"
    workspaces {
      tags = ["hashicupsBackend"]
    }
  }
}

resource "random_pet" "sg" {}

output "pet" {
  value = random_pet.sg.id
}
