output "repository_name" {
  description = "The name of the repository"
  value       = github_repository.repo.name
}

output "repository_html_url" {
  description = "The HTML URL of the repository"
  value       = github_repository.repo.html_url
}

output "repository_git_clone_url" {
  description = "The Git clone URL of the repository"
  value       = github_repository.repo.git_clone_url
}

output "repository_id" {
  description = "The ID of the repository"
  value       = github_repository.repo.repo_id
}

output "tags" {
  description = "The tags that were created"
  value       = keys(var.tags)
}