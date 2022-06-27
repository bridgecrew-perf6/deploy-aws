# Hosting a Full-Stack Application - AWS

- [x] environment variables.
- [x] root package.json file.
- [x] Infrastructure configuration
  - [x] AWS RDS.
  - [x] AWS ElasticBeanstalk.
  - [x] AWS s3.
- [x] Configuring Continuous using `Circle CI`.
- [x] pipeline file using the config.yml.


> Front-End app run at: http://my-275323461198-bucket.s3-website-us-east-1.amazonaws.com

> Back-End app run at: http://udagram-env.eba-e89egzw3.us-east-1.elasticbeanstalk.com/



## Preparing source code infrastructure for deployment

### Bucket permesion
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
