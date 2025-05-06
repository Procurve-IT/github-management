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

resource "null_resource" "repo_tags" {
  for_each = var.tags
  
  depends_on = [github_repository.repo]
  
  triggers = {
    tag_name    = each.key
    tag_message = each.value
    repo_name   = github_repository.repo.name
  }

  provisioner "local-exec" {
    command = <<-EOT
      if [ ! -d "temp_${github_repository.repo.name}" ]; then
        git clone https://${var.github_token}@github.com/${var.github_owner}/${github_repository.repo.name}.git temp_${github_repository.repo.name}
      fi
      cd temp_${github_repository.repo.name}
      git tag -a ${each.key} -m "${each.value}"
      git push origin ${each.key}
    EOT
  }
}

# Clean up at the end
resource "null_resource" "cleanup" {
  depends_on = [null_resource.repo_tags]
  
  triggers = {
    repo_name = github_repository.repo.name
  }

  provisioner "local-exec" {
    command = "rm -rf temp_${github_repository.repo.name}"
  }
}