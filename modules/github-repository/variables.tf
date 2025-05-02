variable "name" {
  description = "The name of the repository"
  type        = string
}

variable "description" {
  description = "A description of the repository"
  type        = string
  default     = ""
}

variable "visibility" {
  description = "The visibility of the repository"
  type        = string
  default     = "private"
  validation {
    condition     = contains(["public", "private", "internal"], var.visibility)
    error_message = "Visibility must be one of 'public', 'private', or 'internal'."
  }
}

variable "has_issues" {
  description = "Enable GitHub issues"
  type        = bool
  default     = true
}

variable "has_projects" {
  description = "Enable GitHub projects"
  type        = bool
  default     = false
}

variable "has_wiki" {
  description = "Enable GitHub wiki"
  type        = bool
  default     = false
}

variable "allow_merge_commit" {
  description = "Allow merge commits"
  type        = bool
  default     = true
}

variable "allow_rebase_merge" {
  description = "Allow rebase merges"
  type        = bool
  default     = true
}

variable "allow_squash_merge" {
  description = "Allow squash merges"
  type        = bool
  default     = true
}

variable "delete_branch_on_merge" {
  description = "Delete branch on merge"
  type        = bool
  default     = true
}

variable "auto_init" {
  description = "Auto initialize repository with README"
  type        = bool
  default     = true
}

variable "archived" {
  description = "Archive the repository"
  type        = bool
  default     = false
}

variable "template" {
  description = "Template repository to use"
  type = object({
    owner                = string
    repository           = string
    include_all_branches = optional(bool, false)
  })
  default = null
}

variable "pages" {
  description = "GitHub Pages configuration"
  type = object({
    branch = string
    path   = optional(string, "/")
  })
  default = null
}

variable "vulnerability_alerts" {
  description = "Enable vulnerability alerts"
  type        = bool
  default     = true
}

variable "branch_protections" {
  description = "Branch protection rules"
  type = map(object({
    strict_status_checks  = bool
    status_check_contexts = list(string)
    dismiss_stale_reviews = bool
    required_approvers    = number
    enforce_admins        = bool
  }))
  default = {}
}