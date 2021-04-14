resource awx_inventory "iweb-inventory" {
  name            = "iweb-inventory"
  organisation_id = awx_organization.arnoldclark.id
  variables       = <<YAML
---
abc: 123
YAML
}

resource awx_inventory_source "iweb-inventory-source" {
    description        = "source inventory, added by tf and other useful info"
    inventory_id       = awx_inventory.iweb-inventory.id
    name               = "iweb-ansible-node-test"
    source_project_id  = awx_project.ansible-node-test.id
    source_path        = "dev/inventory"
    verbosity          = "2" 
    // 2 == debug
}

// resource awx_inventory_group "test-inventory-added-by-tf" {
//     name           = "test-group-added-by-tf"
//     description    = "test group added by tf"
//     inventory_id   = awx_inventory.test-inventory-added-by-tf.id
//     variables      =  <<YAML
// ---
// test: 1234
// YAML
// }