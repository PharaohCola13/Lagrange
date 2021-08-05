---
layout: post
title: "GitHub Workflows: A walkthrough of Docker Containers and the GHCR Part 1"
author: "Spencer Riley"
categories: journal
tags: [documentation,sample]
image: whale_boyle.jpg
status: draft
---

In this short two-part discussion, we will introduce building and publishing a docker image to the GitHub Container Registry and then how to use the docker container in GitHub Workflows.

# Creating a repository secret
To do this, you will need to navigate to your account settings, then travel to `Developer Settings > Personal Access Tokens`. Select the option to create a new token with the name `CR_TOKEN` and select the options: `read:packages`, `write:packages`, and `delete:packages`. I have provided some visuals below to resolve any confusion. 


# Building a Docker container
The basic format of a Docker image will look something like the following directory tree:
```
.
├── Dockerfile
├── README.md
├── action.yml
├── entrypoint.sh
```
If we want to implement GitHub workflows into building this system, then we will need to create a `.github/workflows/` file for this operation.

```yml
jobs:
  publish_package:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout Branch
      uses: actions/checkout@master
      with:
       ref: [branch with docker files]
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
The first part of this workflow will be to check out the repository, to make things easier I have included the argument that allows the workflow to check out an arbitary branch in your repository. Simply replace the contents of `ref` with the name of the branch that contains your docker files. 

The next step will be to add a secret to your repository. Refer to the previous section of this guide for the instructions on how to do that. 

Finally, you can replace the `[username]` placeholders with your GitHub username, the `[name]` placeholder with the name of your package and, `[tag]` is a placeholder for the container tag. `latest` is often used for the container tag. However, if you are using a more sophisticated versioning system than simply replace `[tag]` with your scheme. 

Once the workflow file is configured then it is just a matter of how you want to active it. For an in-depth list of possible triggers, refer to the GitHub documentation [here](https://docs.github.com/en/actions/reference/events-that-trigger-workflows). In my specific workflow, I have the script activate when another workflow (one that updates the source files on the `deployment` branch of the repo) is complete. In addition, I have it setup such that I can trigger the workflow manually with `workflow_dispatch`. 
```yml
on:
  workflow_run:
    workflows: ["name of other workflow"]
    types: [completed]
  workflow_dispatch:
```
More often than not you may need need to trigger on a simple push, rather than something more complicated. 
```yml
on: [push]
```
There are a lot of possible ways to trigger workflows so I would reccommend looking at the previously mentioned [GitHub Documentation page for event triggers](https://docs.github.com/en/actions/reference/events-that-trigger-workflows). 

# Conclusion
So, to wrap up. We have briefly discussed how to make a GitHub workflow build and publish to the GitHub Container Registary, and how to activate the workflow. I have added the complete workflow file that we have put together in this short tutortial at the bottom for reference or easy copypasta. 

## Example Workflow
```yml
name: Example GHCR tutorial
on: [push]
jobs:
  publish_package:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout Branch
      uses: actions/checkout@master
      with:
       ref: [branch with docker files]
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
