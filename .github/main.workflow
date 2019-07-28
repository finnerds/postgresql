workflow "Docker workflow" {
  on = "push"
  resolves = ["Docker build"]
}

action "Docker build" {
  uses = "actions/docker/cli@86ff551d26008267bb89ac11198ba7f1d807b699"
  secrets = ["GITHUB_TOKEN"]
  runs = "docker build"
}
