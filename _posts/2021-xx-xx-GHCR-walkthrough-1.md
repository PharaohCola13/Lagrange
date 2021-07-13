---
layout: post
title: "GitHub Workflows: A walkthrough of Docker Containers and the GHCR Part 1"
author: "Spencer Riley"
categories: journal
tags: [documentation,sample]
image: cutting.jpg
---

In this short two-part discussion, we will introduce building and publishing a docker image to the GitHub Container Registry and then how to use the docker container in GitHub Workflows.

# Building a Docker Container
The basic format of a Docker image will look something like the following directory tree:
```
.
├── Dockerfile
├── README.md
├── action.yml
├── entrypoint.sh
```
If we want to implement GitHub workflows into building this system, then we will need to create a `.github/workflows/` file for this operation.

The first part of this workflow will be to check out the repository, if you are building this docker image on a branch other than master or main than you will need to input the name of the branch in the `ref` field as shown below.

The next step will be to add a secret to your repository. To do this, you will need to navigate to your account settings, then travel to `Developer Settings > Personal Access Tokens`. Select the option to create a new token with the name `CR_TOKEN` and select the options: `read:packages`, `write:packages`, and `delete:packages`.

```yml
jobs:
  publish_package:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout Branch
      uses: actions/checkout@master
      with:
       ref: [branch with docker image]
       
    - name: Login to GHCR
      run: |
        echo $CR_PAT | docker login ghcr.io -u [username] --password-stdin
      env:
        CR_PAT: ${{ secrets.CR_TOKEN }}
    - name: Build Package
      run: |
        docker build . --tag ghcr.io/[username]/[name]:[tag]
        docker push ghcr.io/[username]/[name]:[tag]
```
