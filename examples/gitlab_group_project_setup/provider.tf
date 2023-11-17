provider "gitlab" {
  token = var.gitlab_access_token
  base_url = "${local.gitlab_url}/api/v4/"
}