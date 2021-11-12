terraform {
  cloud {
    hostname = "app.terraform.io"
    organization = "hashicorp-learn"
    workspaces {
      tags = ["hashicupsBackend"]
    }
  }
}
