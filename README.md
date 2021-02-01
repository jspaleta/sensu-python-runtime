# Sensu Go Python Runtime Assets
This project is a fork of https://github.com/jspaleta/sensu-python-runtime

Tried building docker image and extracting asset from container as per the instructions in the above repo.
But, faced SSL related issues when installing python using pyenv.
Built docker image manually and pushed to dockerhub `siva9427/centos6-python-3.6.12:latest`

This repo is used to create python-runtime using `siva9427/centos6-python-3.6.12:latest` image and with 3rd party libraries and upload asset to S3 bucket - *objectrocket-product-versions/sensu/assets*

###Steps to build python-runtime with 3rd party libraries:
1. Update the `requirements.txt` file with required 3rd party libraries.
2. Run the Jenkins job to build and upload asset - https://jenkins.objectrocket.com/job/Sensu-runtime-asset-CentOS6-python3.6.12/