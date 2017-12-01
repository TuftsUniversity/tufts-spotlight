%w(
  .ruby-version
  .rbenv-vars
  tmp/restart.txt
  tmp/caching-dev.txt
  config/fedora_fields.yml
).each { |path| Spring.watch(path) }