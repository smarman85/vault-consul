# Vault with Consul backend
## Don't copy this into production. Passwords/encrytion keys in git are highly insecure.
Use below as reference

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

```
       curl --request POST --data '{"key": "AArAS4jZA9TKz0dd/kx6Fw+ap7fAeYxwI4yz3JJYm3k="}' http://127.0.0.1:8200/v1/sys/unseal | jq
   13  vim payload.json
   17  curl --request POST --data '{"type": "database", "config": {"force_no_cache": true}}' http://127.0.0.1:8200/v1/sys/mounts/database
   18  curl --request POST --data --header "X-Vault-Token: $ROOT_TOKEN" '{"type": "database", "config": {"force_no_cache": true}}' http://127.0.0.1:8200/v1/sys/mounts/database
   19  env
   20  curl --request POST --data --header "X-Vault-Token: $VAULT_TOKEN" '{"type": "database", "config": {"force_no_cache": true}}' http://127.0.0.1:8200/v1/sys/mounts/database
   21  curl --request POST --header --data "X-Vault-Token: $VAULT_TOKEN" '{"type": "database", "config": {"force_no_cache": true}}' http://127.0.0.1:8200/v1/sys/mounts/database
   22  history
```


    1  curl --request POST --data '{"secret_shares": 1, "secret_threshold": 1}' http://127.0.0.1:8200/v1/sys/init
    2  export VAULT_TOKEN="s.jYl9sPUVBmelhdOuPJzU7dEn"
    4  curl --request POST --data '{"key": "ygZ/s4SCaA3NKT9eK8DSFNOSTWnGOBymAhUxRJRBn78="}' http://127.0.0.1:8200/v1/sys/unseal | jq
    8  curl --request POST --header "X-Vault-Token: $VAULT_TOKEN" --data '{"type": "database", "config": { "force_no_cache": true}}' http://127.0.0.1:8200/v1/sys/mounts/database
    9  history
```

```
curl --request POST --data '{"secret_shares": 1, "secret_threshold":1}' http://127.0.0.1:8200/v1/sys/init | jq
export VAULT_TOKEN="s.hxTajujxdtLQFARAuxBjlZ40"

curl --request POST \
  --data '{"key": "AArAS4jZA9TKz0dd/kx6Fw+ap7fAeYxwI4yz3JJYm3k="}' \
  http://127.0.0.1:8200/v1/sys/unseal | jq

curl --request POST \
  --header "X-Vault-Token: $VAULT_TOKEN" \
  --data '{"plugin_name": "mysql-database-plugin", "connection_url": "{{username}}:{{password}}@tcp(vault-consul_mysql_1:3306)/", "allowed_roles": "read-only", "username": "vaultUser", "password": "S3cretPass"}' \
  http://127.0.0.1:8200/v1/database/config/test_db

curl --request POST \
  --header "X-Vault-Token: $VAULT_TOKEN" \
  --data "{\"db_name\": \"test_db\", \"creation_statements\": \"CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT SELECT ON test_db.* TO '{{name}}'@'%';\", \"default_ttl\": \"10m\", \"max_ttl\": \"24h\" }" \
  http://127.0.0.1:8200/v1/database/roles/read-only
```



vault secrets enable -path=secret/ kv
or:
vault secrets enable kv-v2
vault secrets enable -version=2 -path=secret/ kv


Unseal Key 1: Rm2m9ydgNLi2g15JkK016ZChzj5CkxxoECOtJMxunoQ=

Initial Root Token: s.7hePQ91k0IcG2P5koW32CSMc




#round2:
consul token: 4d1e3588-5018-e39b-d186-0f53f3e3e222
Unseal Key 1: 88vTndXA7d4EPYJEVBg2xElooa1SWYnTKDIuSExypgU=
Initial Root Token: s.1U98HtalgnY0oaxgij8GZWFr
