path "secret/metadata/qa/*" {
  capabilities = ["list"]
}

path "secret/data/qa/global/kingdom-keys" {
  capabilities = ["deny"]
}
path "secret/metadata/qa/global/*" {
  capabilities = ["deny"]
}
