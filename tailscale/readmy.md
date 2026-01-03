#tailscale install 


use this command for install and start tailscale 
```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up

```
this command return the link use this link on login in tailscale.

utils command
```
tailscale status -> print the status the tailscale
sudo tailscale up --ssh -> this command enable ssh in network(the tailscale) and set pc-name for dns 
sudo hostnamectl set-hostname novo-nome -> use this command for change the host_name in tailscale
```
