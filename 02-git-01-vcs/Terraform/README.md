# Local .terraform directories (Локальные директории .Terraform)
**/.terraform/*

# .tfstate files (Файлы .tfstate)
*.tfstate
*.tfstate.*

# Crash log files (Лог ошибок)
crash.log
crash.*.log

# Exclude all .tfvars files, which are likely to contain sentitive data, such as (Исключение файлов .tfvars, в которых содержатся пароли, закрытые ключи и т.д.)
# password, private keys, and other secrets. These should not be part of version
# control as they are data points which are potentially sensitive and subject
# to change depending on the environment.
#
*.tfvars

# Ignore override files as they are usually used to override resources locally and so (Игнорировать файлы переопределения)
# are not checked in
override.tf
override.tf.json
*_override.tf
*_override.tf.json

# Include override files you do wish to add to version control using negated pattern (Включить файлы переопределения используя отрицательный шаблон)
#
# !example_override.tf

# Include tfplan files to ignore the plan output of command: terraform plan -out=tfplan
# example: *tfplan*

# Ignore CLI configuration files (Игнорировать конфигурационные файлы CL)
.terraformrc
terraform.rc
