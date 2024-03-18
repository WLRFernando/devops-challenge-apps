resource "aws_ecr_repository" "ecr" {
  name                 = var.app_name
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "docker_image" "this" {
 name = format("%v:%v", aws_ecr_repository.ecr.repository_url, formatdate("YYYY-MM-DD'T'hh-mm-ss", timestamp()))

 build { 
    context = var.docker_context_path
 } 
}

resource "docker_registry_image" "this" {
 keep_remotely = true 
 name = resource.docker_image.this.name

}