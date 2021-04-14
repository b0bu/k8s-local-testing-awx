resource "awx_project" "ansible-node-test" {
  name                 = "ansible-node-test"
  description          = "ansible node testing, added by tf"
  scm_type             = "git"
  scm_url              = "git@github.com:ac-obair/ansible-node-test.git"
  scm_branch           = "main"
  scm_update_on_launch = true
  scm_credential_id    = awx_credential_scm.ac-obiar-scm-credentials.id
  organisation_id      = awx_organization.arnoldclark.id
}