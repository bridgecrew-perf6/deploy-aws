# Hosting a Full-Stack Application - AWS
Work on deploying a full-stack app using AWS cloud services provided on this checklist

- [x] environment variables.
- [x] root package.json file.
- [x] Infrastructure configuration
  - [x] AWS RDS.
  - [x] AWS ElasticBeanstalk.
  - [x] AWS s3.
- [x] Configuring Continuous dedployment using `Circle CI`.
- [x] pipeline file using the config.yml.


> Front-End app run at: http://my-275323461198-bucket.s3-website-us-east-1.amazonaws.com

> Back-End app run at: http://udagram-env.eba-e89egzw3.us-east-1.elasticbeanstalk.com/

## Project Archticture
![alt text for screen readers](/doc/img/projectArchtiecture.jpeg "Create database details")

## Overview of the pipeline
![alt text for screen readers](/doc/img/pipeline.png "Create database details")

## Preparing source code infrastructure for deployment

created .env file to configure all parameters required in the project
``` .env
# environment variables
POSTGRES_USERNAME=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=postgres
PORT=3000
POSTGRES_HOST=database-1.ce2vvmms8hwj.us-east-1.rds.amazonaws.com
URL=http://my-275323461198-bucket.s3-website-us-east-1.amazonaws.com
JWT_SECRET=secrtkey
```

Project-level `package.json` file
It is created to run scripts of server side and clint side.
``` json
{
    "scripts": {
        "frontend:install": "cd udagram/udagram-frontend && npm install -f",
        "frontend:build": "cd udagram/udagram-frontend && npm run build",
        "frontend:test": "cd udagram/udagram-frontend && npm run test",
        "frontend:deploy": "cd udagram/udagram-frontend && npm run deploy",
        "api:install": "cd udagram/udagram-api && npm install .",
        "api:build": "cd udagram/udagram-api && npm run build",
        "api:deploy": "cd udagram/udagram-api && npm run deploy"
    }
}
```

## Create and configure AWS services

### AWS RDS: 
Create a database
![alt text for screen readers](/doc/img/create_RDS.png "Create database details")

1. AWS RDS for the database created
![alt text for screen readers](/doc/img/RDS_1.png "Active databases")

2. Endpoint & database information
![alt text for screen readers](/doc/img/RDS_2.png "Active databases")

3. Add new rule to make database public access by add `0.0.0.0/0` for any ip adress
![alt text for screen readers](/doc/img/RDS_3.png "Active databases")

4. Connect database from pgAdmin
![alt text for screen readers](/doc/img/RDS_4.png "Active databases")

5. Conection success and show the tables.
![alt text for screen readers](/doc/img/RDS_5.png "Active databases")

### AWS ElasticBeanstalk
Creat an ElasticBeanstalk for api

1. Select web server environment.
![alt text for screen readers](/doc/img/api_1.png "ElasticBeanstalk")

2. Bucket is public and ready to upload files.
![alt text for screen readers](/doc/img/api_2.png "ElasticBeanstalk")

3. Add new user group has adminstrator access to allaw cli upload.
![alt text for screen readers](/doc/img/api_3.png "ElasticBeanstalk")

4. Update buchet policy.
![alt text for screen readers](/doc/img/api_4.png "ElasticBeanstalk")

``` json
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "eb-ad78f54a-f239-4c90-adda-49e5f56cb51e",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::275323461198:role/aws-elasticbeanstalk-ec2-role"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::elasticbeanstalk-us-east-1-275323461198/resources/environments/logs/*"
        },
        {
            "Sid": "eb-af163bf3-d27b-4712-b795-d1e33e331ca4",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::275323461198:role/aws-elasticbeanstalk-ec2-role"
            },
            "Action": [
                "s3:ListBucket",
                "s3:ListBucketVersions",
                "s3:GetObject",
                "s3:GetObjectVersion"
            ],
            "Resource": [
                "arn:aws:s3:::elasticbeanstalk-us-east-1-275323461198",
                "arn:aws:s3:::elasticbeanstalk-us-east-1-275323461198/resources/environments/*"
            ]
        },
        {
            "Sid": "eb-58950a8c-feb6-11e2-89e0-0800277d041b",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": "s3:DeleteBucket",
            "Resource": "arn:aws:s3:::elasticbeanstalk-us-east-1-275323461198"
        }
    ]
}
```

5. App run and deploied as health.
![alt text for screen readers](/doc/img/api_5.png "ElasticBeanstalk")

6. Now app run at <http://udagram-env.eba-e89egzw3.us-east-1.elasticbeanstalk.com/>.
![alt text for screen readers](/doc/img/api_6.png "ElasticBeanstalk")

7. Finaly the enviroment and app are ready.
![alt text for screen readers](/doc/img/api_7.png "ElasticBeanstalk")

### AWS S3
Now i create the s3 bucket to host the client side app.

1. Creat new bucket.
![alt text for screen readers](/doc/img/s3_1.png "Create s3")

2. Creat new bucket.
![alt text for screen readers](/doc/img/s3_2.png "Create s3")

3. Creat new bucket.
![alt text for screen readers](/doc/img/s3_3.png "Create s3")

4. Now i have new adminstrator use calles `cli`.
![alt text for screen readers](/doc/img/s3_4.png "Create s3")

### Configuring Continuous dedployment using `Circle CI`

1. Create `config.yml` file in side `.circleci` folder.

2. Write the config statment pipline in side config.yml

``` yml
version: 2.1
orbs:
  # orgs contain basc recipes and reproducible actions (install node, aws, etc.)
  node: circleci/node@5.0.2
  eb: circleci/aws-elastic-beanstalk@2.0.1
  aws-cli: circleci/aws-cli@3.1.1
  # different jobs are calles later in the workflows sections
jobs:
  build:
    docker:
      # the base image can run most needed actions with orbs
      - image: "cimg/node:14.15"
    steps:
      # install node and checkout code
      - node/install:
          node-version: '14.15'         
      - checkout
      # Use root level package.json to install dependencies in the frontend app
      - run:
          name: Install Front-End Dependencies
          command: |
            echo "NODE --version" 
            echo $(node --version)
            echo "NPM --version" 
            echo $(npm --version)
            npm run frontend:install
      # TODO: Install dependencies in the the backend API          
      - run:
          name: Install API Dependencies
          command: |
           echo "TODO: Install dependencies in the the backend API  "
           npm run api:install
      # TODO: Build the frontend app
      - run:
          name: Front-End Build
          command: |
            echo "TODO: Build the frontend app"
            npm run frontend:build
      # TODO: Build the backend API      
      - run:
          name: API Build
          command: |
            echo "TODO: Build the backend API"
            npm run api:build
  # deploy step will run only after manual approval
  deploy:
    docker:
      - image: "cimg/base:stable"
    steps:
      - node/install:
          node-version: '14.15' 
      - eb/setup
      - aws-cli/setup
      - checkout
      - run:
          name: Deploy App
          # TODO: Deploy app
          command: |
            npm run frontend:deploy
            
workflows:
  udagram:
    jobs:
      - build
      - hold:
          filters:
            branches:
              only:
                - master
          type: approval
          requires:
            - build
      - deploy:
          requires:
            - hold
```

3. Config project with Circle Ci platform.

4. Write deploy script at udagram-frontend/`package.json`
``` json
{
    "deploy": "npm install -f && npm run build && chmod +x bin/deploy.sh && bin/deploy.sh",
}
```

Where the deploy.sh file cinfigured wiht my-bucket name
``` sh
    aws s3 cp --recursive --acl public-read ./www s3://my-275323461198-bucket/
```

5. Auth AWS user by set environment variable.
![alt text for screen readers](/doc/img/s3_5.png "CircleCi")

6. Now push the project and will show the workflows starts at Circle CI as show.
![alt text for screen readers](/doc/img/s3_6.png "CircleCi")

7. The build proccess done successfuly and be hold for apove.
![alt text for screen readers](/doc/img/s3_7.png "CircleCi")

8. Aproved for start Deploy.
![alt text for screen readers](/doc/img/s3_8.png "CircleCi")

9. Deploy done successfuly.
![alt text for screen readers](/doc/img/s3_9.png "CircleCi")

10. Finaly it linked with github.
![alt text for screen readers](/doc/img/circleCi.png "CircleCi")
