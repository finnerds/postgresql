workflow "Docker workflow" {
  on = "push"
  resolves = [
    "Docker build master",
    "Docker build standby",
  ]
}

action "Docker build master" {
  uses = "actions/docker/cli@86ff551d26008267bb89ac11198ba7f1d807b699"
  secrets = ["GITHUB_TOKEN"]
  runs = "docker build master"
}

action "Docker build standby" {
  uses = "actions/docker/cli@86ff551d26008267bb89ac11198ba7f1d807b699"
  runs = "docker build standby"
}
