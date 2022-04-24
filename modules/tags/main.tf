
locals {
  tag_namespaces = {
    "k8s-operations" : {
      tag_namespace_description : "k8s Operations test1 and test111",
      tags : [{
        name : "Cost",
        tag_description : "cost"
        tag_is_cost_tracking : true
        },
        {
          name : "Department",
          tag_description : "Department test",
          tag_is_cost_tracking : false
      }]
    }
  }
}

locals {
  # flatten ensures that this local value is a flat list of objects, rather
  # than a list of lists of objects.
  tags = flatten([
    for namespace_name, namespace in local.tag_namespaces : [
      for tag in namespace.tags : {
        name : tag.name,
        tag_description : tag.tag_description,
        tag_is_cost_tracking: tag.tag_is_cost_tracking,
        namespace : namespace_name
      }
    ]
  ])
}

# https://learn.hashicorp.com/tutorials/terraform/for-each?in=terraform/configuration-language#add-for_each-to-the-vpc
resource "oci_identity_tag_namespace" "tag_namespaces" {

  for_each = local.tag_namespaces # 循环
  #Required
  compartment_id = var.compartment_id
  description    = local.tag_namespaces[each.key].tag_namespace_description
  name           = each.key

  #Optional
  is_retired = false
}
resource "oci_identity_tag" "tags" {

  for_each = {
    for tag in local.tags : "${tag.name}" => tag
  }

  #Required
  description      = each.value.tag_description
  name             = each.value.name
  tag_namespace_id = oci_identity_tag_namespace.tag_namespaces[each.value.namespace].id
  is_cost_tracking = each.value.tag_is_cost_tracking

  is_retired = false
}
