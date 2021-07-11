######################################################################################################################
# Secrets ############################################################################################################
######################################################################################################################
variable "do_token" {
  description = "DigitalOcean Personal Access Token."
  sensitive   = true

  validation {
    condition     = length(var.do_token) == 64
    error_message = "Invalid DigitalOcean personal access token -- PATs are 64 characters long."
  }
}

# NOTE: It cannot be password protected.
variable "do_terraform_ssh_key_path" {
  description = "Local path to the Terraform SSH key that's been uploaded to DigitalOcean."

  validation {
    condition     = fileexists(var.do_terraform_ssh_key_path)
    error_message = "Invalid path to local SSH key -- the file doesn't exist."
  }
}

# Check the name on https://cloud.digitalocean.com/account/security
# NOTE: It must be the same key as in `var.do_terraform_ssh_key_path`.
variable "do_terraform_ssh_key_name" {
  description = "Name of the Terraform SSH key uploaded to DigitalOcean account, as visible on the list."
  default     = "id_ed25519_digitalocean_terraform"
}

# Check the name on https://cloud.digitalocean.com/account/security
# NOTE: It must be the same key as in `var.do_login_ssh_key_path`.
variable "do_login_ssh_key_name" {
  description = "Name of the root login SSH key uploaded to DigitalOcean account, as visible on the list."
  default     = "id_ed25519_digitalocean"
}

######################################################################################################################
# DigitalOcean Droplet settings. See: https://slugs.do-api.dev #######################################################
######################################################################################################################
variable "droplet_image_type" {
  default = "ubuntu-20-04-x64"
}

variable "droplet_region" {
  default = "fra1"
}

variable "droplet_size" {
  default = "s-1vcpu-1gb"
}

# It only becomes important when there are multiple VPCs on the account which may overlap.
variable "vpc_ip_range" {
  default = "10.10.10.2/24"
}
