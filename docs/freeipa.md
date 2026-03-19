# FreeIPA Setup Reference

## Architecture

- **Host**: `superdator` at `10.22.1.100/16` on `br0` (company LAN)
- **FreeIPA VM**: microvm at `10.22.255.2/24` on isolated bridge `br-freeipa`
- **Host bridge IP**: `10.22.255.1/24` (gateway for the VM)
- **Realm**: `INTERNAL.SUPERDATOR`
- **Domain**: `internal.superdator`
- **Hostname**: `freeipa.internal.superdator`

## Networking (superdator)

- `br-freeipa` is an isolated bridge — the VM is not directly on the company LAN
- NAT is enabled (`br-freeipa` → `br0`) so the VM can reach the internet
- FORWARD rules allow LAN clients routed via `superdator` to reach `10.22.255.0/24` directly
- LAN clients must add a static route: `10.22.255.0/24 via 10.22.1.100`

## Persistence

FreeIPA data is stored on the host via virtiofs:
- Host path: `/var/lib/microvms/freeipa/`
- VM mount point: `/var/lib/freeipa`

The `freeipa-env` systemd service on the host writes `/var/lib/microvms/freeipa/freeipa.env`
before the VM starts. This file contains `PASSWORD` and `IPA_SERVER_INSTALL_OPTS`.

## Persistent Route on NetworkManager Clients

On Linux machines managed by NetworkManager, `ip route add ...` is not persistent and will be lost after reboot or reconnect.

To make the route to the FreeIPA subnet persistent for a specific Wi-Fi connection:

```bash
sudo nmcli connection modify 'Hitachigymnasiet' +ipv4.routes "10.22.255.0/24 10.22.1.100"
sudo nmcli connection up 'Hitachigymnasiet'
```

To verify:

```bash
nmcli connection show 'Hitachigymnasiet' | rg '^ipv4.routes'
ip route get 10.22.255.2
```

Expected result: traffic to 10.22.255.0/24 should go via 10.22.1.100 instead of being treated as directly reachable on the local LAN.

To remove the persistent route later:

```bash
sudo nmcli connection modify 'Hitachigymnasiet' -ipv4.routes "10.22.255.0/24 10.22.1.100"
sudo nmcli connection up 'Hitachigymnasiet'
```


## Secrets

Password is managed via sops at `freeipa/password` in `secrets/secrets.yaml`.

To view:
```bash
sops exec-file secrets/secrets.yaml 'grep -A1 freeipa {}'
```

## Accessing the Web UI

### From a LAN machine (Linux)
```bash
# Add route (persist in netplan for Ubuntu)
sudo ip route add 10.22.255.0/24 via 10.22.1.100

# Add hosts entry
echo "10.22.255.2 freeipa.internal.superdator" | sudo tee -a /etc/hosts
```

Open `https://freeipa.internal.superdator` — accept the self-signed cert warning.

### From Windows
Admin PowerShell:
```powershell
route add 10.22.255.0 mask 255.255.255.0 10.22.1.100
Add-Content -Path "C:\Windows\System32\drivers\etc\hosts" -Value "10.22.255.2 freeipa.internal.superdator"
ipconfig /flushdns
```

To trust the cert, install the FreeIPA CA:
1. Open `http://10.22.255.2/ipa/config/ca.crt`
2. Double-click → Install Certificate → Local Machine → Trusted Root Certification Authorities

## Enrolling a Linux Client

```bash
# Get CA cert
sudo mkdir -p /etc/ipa
ssh <user>@<superdator-ip> "cat /var/lib/microvms/freeipa/etc/ipa/ca.crt" | sudo tee /etc/ipa/ca.crt

# Add route and hosts entry
sudo ip route add 10.22.255.0/24 via 10.22.1.100
echo "10.22.255.2 freeipa.internal.superdator" | sudo tee -a /etc/hosts

# Set FQDN hostname
sudo hostnamectl set-hostname <machine>.internal.superdator

# Enroll
sudo ipa-client-install \
  --server=freeipa.internal.superdator \
  --domain=internal.superdator \
  --realm=INTERNAL.SUPERDATOR \
  --ca-cert-file=/etc/ipa/ca.crt \
  --mkhomedir
```

Answer the prompts:
- Proceed with fixed values: `yes`
- Configure chrony NTP: `no`
- Continue with values: `yes`
- User: `admin`, Password: (from sops)

## Managing Users, or just use the Web UI

SSH into the VM and exec into the container:
```bash
ssh -J <user>@<superdator-ip>r root@10.22.255.2
podman exec -it freeipa bash
kinit admin
ipa user-add username --first=First --last=Last --password
```

## Resetting the Installation

If FreeIPA data is corrupt or you need to reinstall:
```bash
# On superdator
podman stop freeipa  # if running interactively on the VM
rm -rf /var/lib/microvms/freeipa/*
# Restart the VM - systemd will recreate the env file and the container will reinstall
sudo systemctl restart microvm@freeipa.service
```

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| Container crash-loops with `statfs /var/lib/freeipa: no such file or directory` | Mount not ready | Check virtiofs share and `systemd.tmpfiles` |
| `sysctl ... can't be set since Network Namespace set to host` | Incompatible `--sysctl` with `--network=host` | Remove `--sysctl` option |
| `/etc/hosts` conflict with `host.containers.internal` | Podman injects hosts | Add `--no-hosts` to container extraOptions |
| Installer fails at client step with hostname error | Not FQDN | Run `hostnamectl set-hostname <name>.internal.superdator` |
| `Kerberos authentication failed: Password incorrect` | Wrong admin password | Check sops secret or reset via `ipa user-mod admin --password` inside container |
| `JSON-RPC call failed: SSL ... not OK` | Enrollment hitting wrong TLS cert | Ensure client routes directly to `10.22.255.2`, not through a proxy |

## Creating a New User

To create a new user, use the web UI available at `freeipa.internal.superdator`. Create the user and optionally assign appropriate group memberships (e.g. `isaac` for access to robot dev resources under `/opt/`).

### Filling in the Details

| Field | Value |
|---|---|
| User Login | Standard naming convention, e.g. `24guspet` |
| First Name | `<Name>` |
| Last Name | `<Surname>` |
| Password | Set a temporary password, e.g. `1234` |
| Verify Password | Same as above |

> **Note:** The **Class** field is unused — leave it blank.

### Initializing the User

After creating the user in FreeIPA, it should be initialized by an `admins` group member SSHing into `dunning` (`10.22.2.100`) or `kruger` (`10.22.3.100`) and running:

```bash
# Prompts for the temporary password, then forces the user to set a new one
kinit <username>
sudo systemctl restart sssd
```

To inspect a user's details on any enrolled machine:

```bash
ipa user-show <username> --all --raw
```

To check SSH keys registered for a user:

```bash
sss_ssh_authorizedkeys <username>
```

To clear the local SSSD cache (only if `systemctl restart sssd` does not resolve the issue):

```bash
sss_cache -E
```

> **Note:** `sss_cache` is not included in the default FreeIPA client installation. Install it with `sudo apt install sssd-tools` if needed.
