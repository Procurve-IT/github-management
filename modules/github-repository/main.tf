resource "github_repository" "repo" {
  name        = var.name
  description = var.description
  visibility  = var.visibility
  
  has_issues      = var.has_issues
  has_projects    = var.has_projects
  has_wiki        = var.has_wiki
  
  allow_merge_commit = var.allow_merge_commit
  allow_rebase_merge = var.allow_rebase_merge
  allow_squash_merge = var.allow_squash_merge
  
  delete_branch_on_merge = var.delete_branch_on_merge
  auto_init              = var.auto_init
  archived               = var.archived
  
  dynamic "template" {
    for_each = var.template != null ? [var.template] : []
    content {
      owner                = template.value.owner
      repository           = template.value.repository
      include_all_branches = lookup(template.value, "include_all_branches", false)
    }
  }
  
  dynamic "pages" {
    for_each = var.pages != null ? [var.pages] : []
    content {
      source {
        branch = pages.value.branch
        path   = lookup(pages.value, "path", "/")
      }
    }
  }
  
  vulnerability_alerts = var.vulnerability_alerts
}

# Branch protection if enabled
resource "github_branch_protection" "branch_protection" {
  for_each = var.branch_protections

  repository_id = github_repository.repo.name
  pattern       = each.key
  
  required_status_checks {
    strict   = each.value.strict_status_checks
    contexts = each.value.status_check_contexts
  }
  
  required_pull_request_reviews {
    dismiss_stale_reviews           = each.value.dismiss_stale_reviews
    required_approving_review_count = each.value.required_approvers
  }
  
  enforce_admins = each.value.enforce_admins
}

resource "github_release" "example" {
  repository       = github_repository.example.name
  tag_name         = "v1.0.0"
  name             = "v1.0.0"
  description      = "Initial release"
  draft            = false
  prerelease       = false
  generate_release_notes = true
}