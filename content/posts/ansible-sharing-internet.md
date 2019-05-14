+++
title = "Ansible HTTP Proxying with mitmproxy"
date = 2019-04-11
aliases = ["/posts/hello-gutenberg"]

[taxonomies]
tags = ["ansible", "devops"]

[extra]
+++

I've been using ansible for provisioning recently, and bumped into
a situation where I wanted to share my local machine's internet connection
with a remote machine that's isolated from the internet.

The solution involved using the `-R localhost:3128` option of the `ssh`
command to forward TCP traffic from the remote machine's port `3128` to my
local port `3128`.

To use this option we can add `ansible_ssh_extra_args` to our host in the
inventory:

```ini
# inventory
[network_isolated]
remote ansible_ssh_extra_args="-R localhost:3128"
```

Using the `environment` key we can tell our remote hosts to use
`localhost:3128` as a `HTTP` proxy:


```yaml
# playbook.yaml
- hosts: network_isolated
  environment:
    http_proxy: http://localhost:3128
    https_proxy: http://localhost:3128
    no_proxy: "localhost,127.0.0.1"
    HTTP_PROXY: http://localhost:3128
    HTTPS_PROXY: http://localhost:3128
    NO_PROXY: "localhost,127.0.0.1"
  tasks:
    - name: GET http://google.com
      command: wget http://google.com
    - name: GET https://google.com
      command: wget https://google.com
```

So now `HTTP/S` traffic on our remote host is forwarded over the ansible
SSH connection to our local port `3128`. The next step is to ensure our
local machine is forwarding `HTTP/S` traffic on this port.

I chose to use [mitmproxy](https://mitmproxy.org/) as it's incredibly
simple to setup:

```yaml
# playbook.yaml

- hosts: network_isolated
  environment:
    http_proxy: http://localhost:3128
    https_proxy: http://localhost:3128
    no_proxy: "localhost,127.0.0.1"
    HTTP_PROXY: http://localhost:3128
    HTTPS_PROXY: http://localhost:3128
    NO_PROXY: "localhost,127.0.0.1"
  pre_tasks:
    - name: Start mitmproxy
      shell: "(mitmdump -p 3128 --ignore :443$ 2>&1 1>/dev/null &)"
      delegate_to: localhost
  tasks:
    - name: GET http://google.com
      command: wget http://google.com
    - name: GET https://google.com
      command: wget https://google.com
```

We are using `mitmdump` which is essentially `mitmproxy` without the nifty
interface. The `-p 3128` flag tells `mitmdump` to listen on port `3128`,
the `--ignore :443$` flag makes sure we don't intercept `HTTPS` traffic,
which would cause problems with our remote hose finding unexpected TLS
certs.
