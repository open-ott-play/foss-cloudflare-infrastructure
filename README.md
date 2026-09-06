# foss-cloudflare-infrastructure

Terraform for Cloudflare **Zero Trust Access** in front of a private origin (e.g. `inverter-gateway` behind Cloudflare Tunnel).

Manages:

- Self-hosted Access application for a public hostname
- Allow policy (email)
- Access **Service Token** + non-identity policy (for `inverter-desktop` / automation)
- Writes `client_id` / `client_secret` (and optional gateway bearer) to a **gitignored** `local.generated.service-token.json` via `local_sensitive_file`

Optional (off by default): tunnel ingress with **Enforce Access JWT** (`origin_request.access`).

## Secrets layout

| File | In git? | Purpose |
|------|---------|---------|
| `local.secrets.tfvars.example` | yes | Fake template for users |
| `local.secrets.tfvars` | **no** | Real account id, API token, emails, hostname |
| `local.generated.service-token.json` | **no** | Written by apply — desktop reads this |

```bash
cp local.secrets.tfvars.example local.secrets.tfvars
# edit local.secrets.tfvars
terraform init
terraform plan  -var-file=local.secrets.tfvars
terraform apply -var-file=local.secrets.tfvars
```

API token scopes (minimum):

- Account → Zero Trust → Access: **Apps and Policies** Edit
- Account → Zero Trust → Access: **Service Tokens** Edit
- If `manage_tunnel_config=true`: Cloudflare Tunnel Edit

## Existing dashboard resources

If you already created the Access app / email policy in the UI (as with `victron.2560801.xyz`), **import** them instead of recreating — see `import.example.sh`. Then let Terraform create the Service Token (or import that too).

## Tunnel JWT enforce

Dashboard path: Tunnel → Public hostname → **Enforce Access JWT** → select this app.

In Terraform the same thing is `cloudflare_zero_trust_tunnel_cloudflared_config` with:

```hcl
origin_request = {
  access = {
    required  = true
    team_name = var.team_name
    aud_tag   = [cloudflare_zero_trust_access_application.gateway.aud]
  }
}
```

**Warning:** enabling `manage_tunnel_config` replaces the tunnel’s ingress list for that resource. Include every hostname (hass, etc.) in `tunnel.tf` before apply, or keep JWT enforce in the dashboard only.

## Desktop headers

```http
CF-Access-Client-Id: <client_id>
CF-Access-Client-Secret: <client_secret>
Authorization: Bearer <GATEWAY_API_TOKEN>
```

## Repo provisioning

GitHub repository is created by [`terraform-github-open-ott-play`](https://github.com/open-ott-play) / org IaC (`foss-cloudflare-infrastructure`).
