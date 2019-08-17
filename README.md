# Action Deploy

<p align="left">
  <a href="https://github.com/bumfo/action-deploy"><img alt="GitHub Actions status" src="https://github.com/bumfo/action-deploy/workflows/Auto%20deploy/badge.svg"></a>
</p>

This action deploys actions to release branch upon push


## Usage

```yml
name: "Auto deploy"
on: 
  push:
    branches:
    - master

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v1
    - uses: bumfo/action-deploy@v1
      with:
        ref: 'refs/heads/release/snapshot'  # The branch to auto deploy, default to release/snapshot
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
