name "mysql-server"
description "mysql server setup for nova"

run_list(
  "recipe[build-essential]",
  "recipe[mysql::server]"
)
