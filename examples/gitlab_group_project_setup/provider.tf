provider "gitlab" {
  token = var.gitlab_access_token
  base_url = "${local.gitlab.url}/api/v4/"
}