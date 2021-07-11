# Git Server Terraformed

Simple Git server setup terraformed.

Refer to cloud provider-specific instructions under `terraform/`.

## Maintenance

### Creating a new repository

SSH as `root` into the Virtual Private Server (VPS), and run the following:

```console
mkdir -p /home/git/<path_to_repositories>/<repository_name>.git
cd /home/git/<path_to_repositories>/<repository_name>.git
git init --bare
cd ..
chown --recursive git <repository_name>.git
```

_Note: because the `git` user's shell has been modified to `git-shell`, it
proves difficult to run single commands using `sudo -u git`. Hence, the
subsequent `chown`._

Then, add the remote in a local repository as follows, or just clone the empty
repository:

```console
git remote add origin git@<url_or_ip>:<path_to_repositories>/<repository_name>.git

# Alternatively:
git clone git@<url_or_ip>:<path_to_repositories>/<repository_name>.git
```

### Local SSH config

Add the following configuration to `~/.ssh/config`:

```text
Host <remote_alias>
  HostName <url_or_ip>
  AddKeysToAgent yes
  PreferredAuthentications publickey
  IdentityFile <path_to_private_ssh_key>
```

Then, the alias can be used instead of the full URL/IP address:

```console
git clone git@<remote_alias>:<path_to_repositories>/<repository_name>.git
```

### Authorising new SSH keys

Add permissions, and the public SSH key to `/home/git/.ssh/authorized_keys`.
Remember to leave a blank line between entries.

```text
no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty
<public_ssh_key>
```
