---
layout: post
title: "GitHub Workflows: A walkthrough of Docker Containers and the GHCR Part 2"
author: "Spencer Riley"
categories: journal
tags: [documentation,sample]
image: whale_boyle.jpg
status: draft
---

Unlike the previous article in this series, this is fairly straight forward. It is this. It is this implementation of running docker images that I have decided to write this series. 

# Using the Docker Container
In the snippet presented below we have the `jobs` component of the workflow. The main focus should be the step labeled `Run docker container`. In this step we can identify a path to a docker container in the GitHub Container Registery (GHCR) with placeholders meant for the username of the GitHub account tied to the docker container, the name of the docker container, and the tag associated with the docker container. 

```yml
jobs:
  docker:
    runs-on: ubuntu-latest
    name: Run Docker
    steps:
    - name: Run docker container
      uses: docker://ghcr.io/[username]/[name]:[tag]
```
If the docker container requires arguments to run, then those can be easily implemented as shown in the following:
```yml
jobs:
  docker:
    runs-on: ubuntu-latest
    name: Run Docker
    steps:
    - name: Run docker container
      uses: docker://ghcr.io/[username]/[name]:[tag]
      with:
        args: [args]
```

# Conclusion
That's it. I really wasn't kidding, this is a very straight forward piece of code. Just as I have before, I will include a more complete workflow file that implements this docker deployment

## Example workflow
```yml
name: Run Docker Container
on: [push]
jobs:
  docker:
    runs-on: ubuntu-latest
    name: Run Docker
    steps:
    - name: Run docker container
      uses: docker://ghcr.io/[username]/[name]:[tag]
```
