# Vault with Consul backend
## Don't copy this into production. Passwords/encrytion keys in git are highly insecure.

## Set up consul
```bash
$ docker exec -it vault-consul_consul bash
$ consul acl bootstrap
  AccessorID:       7cefeaba-ffc7-8e4f-cd4d-6a889ac48dfb
  SecretID:         1ab8759b-25c3-8ee5-abf9-025fbcd43c14
  Description:      Bootstrap Token (Global Management)
  Local:            false
  Create Time:      2019-08-01 17:31:28.3131674 +0000 UTC
  Policies:
     00000000-0000-0000-0000-000000000001 - global-management

root@6dfb2ebaa311:/# export CONSUL_HTTP_TOKEN=1ab8759b-25c3-8ee5-abf9-025fbcd43c14
root@6dfb2ebaa311:/# consul acl policy create -name vault -rules @/consul/vault-policy.hcl
ID:           c0aec406-6b04-310c-1e0a-da835748aec1
Name:         vault
Description:
Datacenters:
Rules:
...

root@6dfb2ebaa311:/# consul acl token create -description "vault agent token" -policy-name vault
AccessorID:       84de7b2f-0c71-e0f9-76e4-2913169a46ec
SecretID:         279fab3e-f830-754f-36e4-434b27f034d3
Description:      vault agent token
Local:            false
Create Time:      2019-08-01 17:41:11.3134091 +0000 UTC
Policies:
   c0aec406-6b04-310c-1e0a-da835748aec1 - vault

root@6dfb2ebaa311:/# consul acl set-agent-token agent 279fab3e-f830-754f-36e4-434b27f034d3
ACL token "agent" set successfully
root@6dfb2ebaa311:/#
```
Copy the token SecretID into:
vim vault-1.1.3/config/vault-config.json
```bash
consul {
  ...
  "token": "279fab3e-f830-754f-36e4-434b27f034d3"
```

## Vault:
```bash
$ docker-compose up -d --build
$ vault operator init -n 3 -t 2
$ vault oeprator unseal (with two output keys)
$ vault login <Root Token>
```
