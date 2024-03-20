terraform {
  backend "s3" {
    bucket = "terraform-state-778899"
    key    = "tf-vm.state"
    region = "us-west-2"
  }
}