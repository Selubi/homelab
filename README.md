# homelab
My `{random.choice([overengineered, janky])}` homelab setup. But hey, that's the point!

Mainly uses Ubuntu Jammy as OS.

Dependencies:
- [1Password Secrets Automation](https://developer.1password.com/docs/secrets-automation) - Secret handling
- [Tailscale](https://tailscale.com/) - Networking

# How this works
A minimalist IaC implementation with SSH and Shell Scripts.

Uses [GitHub Actions](.github/workflows/ssh_task.yml) to inject [inject.sh](./inject.sh) and in turn it will fetch this repo from the internet. From there we can run anything inside [the script folder](./scripts) which the IaC resides.

# Requirements
Set the following on GitHub Secrets:
- `TAILSCALE_SSH_KEY` - SSH key for the injection process
- `OP_SERVICE_ACCOUNT_TOKEN` - 1Password Service Account token for target machine to access all other secrets needed

The target machine needs to have:
- Port 22 open and a known FQDN/IP address
- A user with sudo permissions authorizeable via the aforementioned `TAILSCALE_SSH_KEY`

# Future Considerations
- Move to ansible maybe
