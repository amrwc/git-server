# Git Server Terraformed – DigitalOcean

## Prerequisites

```console
export DO_PAT=<digitalocean_personal_access_token>
export DO_TERRAFORM_SSH_KEY_PATH=<path_to_public_terraform_ssh_key>
```

## Variables

<details>

<summary>Click here to expand</summary>

### `do_token` (required)

DigitalOcean Personal Access Token. Needed for authentication with DigitalOcean
API.

See:
<https://www.digitalocean.com/docs/apis-clis/api/create-personal-access-token>

### `do_terraform_ssh_key_path` (required)

Path to a private SSH key, without a passphrase, that's been added to a
DigitalOcean account. Needed to provision the Droplet.

See:
<https://www.digitalocean.com/docs/droplets/how-to/add-ssh-keys/to-account>

### `do_terraform_ssh_key_name` (optional)

Name of the Terraform SSH key added to a DigitalOcean account (as is visible on
DigitalOcean). Normally, it should be the same SSH key that's been specified in
the `do_terraform_ssh_key_path` variable.

Defaults to `id_ed25519_digitalocean_terraform`.

See:
<https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/ssh_key>

### `do_login_ssh_key_name` (optional)

Name of the root login SSH key added to a DigitalOcean account (as is visible
on DigitalOcean).

Defaults to `id_ed25519_digitalocean`.

### `droplet_image_type` (optional)

Defaults to `ubuntu-20-04-x64`.

### `droplet_region` (optional)

Defaults to `fra1`.

### `droplet_size` (optional)

Defaults to `s-1vcpu-1gb`.

### `vpc_ip_range` (optional)

Defaults to `10.10.10.2/24`.

</details>

## Apply

```console
terraform apply \
    -var="do_token=${DO_PAT}" \
    -var="do_terraform_ssh_key_path=${DO_TERRAFORM_SSH_KEY_PATH}"
```

_Note that the Terraform SSH key has root access to the server. To deny the access, remove the public Terraform SSH key
from `/root/.ssh/authorized_keys`._

## Troubleshooting DigitalOcean

You can use DigitalOcean's API to inspect resources that aren't easily
accessible from the UI. Documentation
[here](https://developers.digitalocean.com/documentation).

Note that each request requires a DigitalOcean Personal Access Token
(`DO_PAT`) in the `Authorization` header.

### VPCs

#### List existing VPCs

```console
curl \
    --request GET \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer ${DO_PAT}"
    'https://api.digitalocean.com/v2/vpcs' \
    | jq
```

#### Remove a VPC

```console
curl \
    --request DELETE \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer ${DO_PAT}"
    'https://api.digitalocean.com/v2/vpcs/<vpc_id>' \
    | jq
```
