data "local_file" "rd_file" {
  count = length(var.files)
  filename = "./modules/tf-kbot/${var.files[count.index]}"
}

resource "github_repository_file" "file" {
  count = length(var.files) 
  repository          = var.repository_name
  branch              = "main"
  file                = "${var.target_path}/${var.files[count.index]}"
  content             = data.local_file.rd_file[count.index].content
  commit_message      = "Managed by Terraform"
  commit_author       = "Terraform User"
  commit_email        = "bergshrund@gmail.com"
  overwrite_on_create = true
}
