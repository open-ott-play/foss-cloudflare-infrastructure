# Reusable account-level policies (Cloudflare provider v5+).
# Attached to the application via the `policies` attribute.

resource "cloudflare_zero_trust_access_policy" "allow_email" {
  account_id = var.account_id
  name       = "allow-email-${var.access_app_name}"
  decision   = "allow"

  include = [
    for email in var.allow_emails : {
      email = {
        email = email
      }
    }
  ]
}

resource "cloudflare_zero_trust_access_service_token" "desktop" {
  account_id = var.account_id
  name       = var.service_token_name
  duration   = var.service_token_duration
}

resource "cloudflare_zero_trust_access_policy" "service_auth_desktop" {
  account_id = var.account_id
  name       = "service-auth-${var.service_token_name}"
  decision   = "non_identity"

  include = [
    {
      service_token = {
        token_id = cloudflare_zero_trust_access_service_token.desktop.id
      }
    }
  ]
}

# Self-hosted Access application protecting the public gateway hostname.
resource "cloudflare_zero_trust_access_application" "gateway" {
  account_id       = var.account_id
  name             = var.access_app_name
  type             = "self_hosted"
  session_duration = var.access_session_duration
  domain           = var.gateway_public_hostname

  destinations = [
    {
      type = "public"
      uri  = var.gateway_public_hostname
    }
  ]

  auto_redirect_to_identity = false

  policies = [
    {
      id         = cloudflare_zero_trust_access_policy.allow_email.id
      precedence = 1
    },
    {
      id         = cloudflare_zero_trust_access_policy.service_auth_desktop.id
      precedence = 2
    }
  ]
}
