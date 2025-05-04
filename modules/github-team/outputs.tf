output "team_id" {
  description = "The ID of the team"
  value       = github_team.team.id
}

output "team_name" {
  description = "The name of the team"
  value       = github_team.team.name
}

output "team_slug" {
  description = "The slug of the team"
  value       = github_team.team.slug
}