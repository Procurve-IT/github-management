resource "github_team" "team" {
  name           = var.name
  description    = var.description
  privacy        = var.privacy
  parent_team_id = var.parent_team_id
}

resource "github_team_membership" "team_member" {
  for_each = var.members
  
  team_id  = github_team.team.id
  username = each.key
  role     = each.value
}

resource "github_team_repository" "team_repos" {
  for_each = var.repositories
  
  team_id    = github_team.team.id
  repository = each.key
  permission = each.value
}