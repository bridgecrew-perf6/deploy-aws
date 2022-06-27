# Pipeline Process

## Overview of the pipeline

![alt text for screen readers](/doc/img/pipeline.png "Create database details")

### Define the orbs:

- nodejs.
- aws-elastic-beanstalk
- aws-cli

### Define the jobs:

- build
    - define the docker container
    - steps
        - install node
        - checkout
        - Install front-end dependencies
        - Install back-end dependencies
        - Build Front-End
        - API Build

-deploy
    - define the docker container
    - steps
        - install node
        - checkout
        - elastic-beanstalk setup
        - aws-cli setup
        - Deploy Front-End
        - Deploy Back-end

### Workflows

first run build script then hold for approval then deploy.