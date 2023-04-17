locals {

  configs = {
    for f in fileset("${local._data_dir}", "**/*.yaml") :
    trimsuffix(f, ".yaml") => yamldecode(file("${local._data_dir}/${f}"))
  }

  config_files = {
    for f in fileset("${local._data_dir}", "**/*.yaml") :
    trimsuffix(f, ".yaml") => "${local._data_dir}${f}"
  }
  # these are usually set via variables
  _base_dir = path.module
  _data_dir = "${local._base_dir}/sample-data/"

}
# output "config_files" {
#   value = local.config_files
# }
# output "configs" {
#   value = local.configs
# }

locals {


  configs_flatten_list = flatten([
    for each_config in local.configs : [
      for key, custom_rule in each_config.custom_rules : [{
        key         = key
        project_id  = each_config.project_id
        custom_rule = custom_rule
        }
      ]

    ]
    ]
  )
  configs_flatten_map = {
    for element in local.configs_flatten_list :
    element.key => { "custom_rule" = values(element) }

  }
  # configs_flatten_map = {
  #   for idx, element in local.configs_flatten_list : idx => element
  # }
}
# output "configs_flatten_list" {
#   value = local.configs_flatten_list
# }
output "configs_flatten_map" {
  value = local.configs_flatten_map
}
