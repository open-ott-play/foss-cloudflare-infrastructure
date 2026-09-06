variable "cloudflare_api_token" {
  description = "Cloudflare API token with Zero Trust Access (and Tunnel Edit if manage_tunnel_config=true). Prefer env CLOUDFLARE_API_TOKEN."
  type        = string
  sensitive   = true
  default     = ""
}

variable "account_id" {
  description = "Cloudflare account ID (Zero Trust / Access lives here)"
  type        = string
}

variable "team_name" {
  description = "Zero Trust team name (subdomain of *.cloudflareaccess.com), e.g. alvit"
  type        = string
}

variable "gateway_public_hostname" {
  description = "Public hostname for the Victron / inverter-gateway Access app"
  type        = string
}

variable "access_app_name" {
  description = "Access application display name"
  type        = string
  default     = "victron-gateway"
}

variable "access_session_duration" {
  description = "Access session duration (e.g. 24h)"
  type        = string
  default     = "24h"
}

variable "allow_emails" {
  description = "Emails allowed by the browser Allow policy"
  type        = list(string)
}

variable "service_token_name" {
  description = "Name for the Access service token (desktop / automation)"
  type        = string
  default     = "inverter-desktop"
}

variable "service_token_duration" {
  description = "Service token lifetime. Use forever for non-expiring."
  type        = string
  default     = "forever"
}

variable "secrets_output_path" {
  description = "Gitignored path where client_id/client_secret JSON is written"
  type        = string
  default     = "local.generated.service-token.json"
}

variable "manage_tunnel_config" {
  description = "If true, manage tunnel ingress JWT enforce for the gateway hostname. Requires tunnel_id and replaces managed ingress entry carefully — review plan."
  type        = bool
  default     = false
}

variable "tunnel_id" {
  description = "Cloudflare Tunnel ID (required when manage_tunnel_config=true)"
  type        = string
  default     = ""
}

variable "tunnel_origin_service" {
  description = "Origin URL cloudflared proxies to (Synology loopback)"
  type        = string
  default     = "http://127.0.0.1:9150"
}

variable "gateway_api_token" {
  description = "Optional: inverter-gateway bearer token to store beside Access secrets for desktop (NOT a Cloudflare secret)"
  type        = string
  sensitive   = true
  default     = ""
}
