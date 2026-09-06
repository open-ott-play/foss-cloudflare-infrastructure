provider "cloudflare" {
  # Prefer API token (Access: Apps/Policies/Service Tokens Write + Tunnel Edit if managing tunnel).
  # Set via CLOUDFLARE_API_TOKEN env, or cloudflare_api_token in local.secrets.tfvars.
  api_token = var.cloudflare_api_token != "" ? var.cloudflare_api_token : null
}
