# Test 2

For these tests please create a Github or Gitlab repository where we can review your source code and any configuration required for your project to
execute. Please make sure the repository is public so it's viewable.

The following test will require you to do the following:
- Create a simple application which has a single "/version" endpoint.
- Containerise your application as a single deployable artifact, encapsulating all dependencies.
- Create a CI pipeline for your application

The application can be written in any programming language.

Please indicate your preferred programming language.

The application should be a simple, small, operable web-style API or service provider. It should implement the following:
- An endpoint which returns basic information about your application in JSON format which is dynamically generated; The following is expected:
    - Applications Version.
    - Last Commit SHA.
    - Description. (This can be hard-coded)

# Solution

As per the requirement a simple API server using Node.js with a single endpoint /version that returns the application version, git sha, and description as json. The project uses Buildkite for continuous integration for demonstration.

Node.js is preferred as it connects the ease of a scripting language (JavaScript) with the power of Unix network programming. Node.js was built on the Google V8 JavaScript engine since it was open-sourced under the BSD license.

## Prerequisites 

 In here  the API is to deployed to Kubernetes cluster in AWS and Buildkite as CI/CD.

1. Git repository setup
- Require Buildkite account to setup.
- connect Buildkite and GitHub. To complete this integration, need admin privileges for the GitHub repository.
- setup build pipeline for GitHub repository, workflow steps provided in the pipeline.yaml file.
- Configure GitHub settings for the pipeline from the pipeline’s Settings page.
- All the development going to work in feature / dev branches.
- Configure trigger build after pushing code by editing the GitHub settings for the Buildkite pipeline and choose 'Trigger Builds after pushing code' checkbox.

2. Kubernetes cluster in Aws is also required which can be created using eksctl, AWS Management Console or AWS CLI. 

## Running locally

Run the the command to build the app container locally. 
    ```docker build -t gbaba/test2 --build-arg=sha="$(git rev-parse --short HEAD)" --build-arg=version="1.0" .```

start the app container.
    ```docker run -it -p 3300:3300 gbaba/test2```

Test the endpoint with curl:
    ```curl -i http://localhost:3300/version```

- Output
    ```
    HTTP/1.1 200 OK
    X-Powered-By: Express
    Content-Type: application/json; charset=utf-8
    Content-Length: 108
    ETag: W/"6c-NaPD0r+RfgbE3jFkiRsarTaeQfE"
    Date: Sun, 19 Jul 2020 13:51:36 GMT
    Connection: keep-alive

    {"myapplication":[{"version":"1.0","lastcommitsha":"96d993a","description":"pre-interview technical test"}]}

Test the endpoint from the root of the project
    ```npm test```

- Output
    ```
    > anztechnicaltest2@1.0.0 test /Users/gumbaba/Documents/anz_test/technical-test2/app
    > mocha tests/unittests/*.js --exit
    
    Server is running on port 3300
    
    Myapplication
    /GET myapplication
      ✓ it should GET all the myapplication

  1 passing (23ms)

## CI/CD Pipeline

The workflow of the pipeline is as follows:

- Once a commit has been pushed up, a build workflow Buildkite will be kicked off.
- Run sonar.sh to do the code chek by Buildkite agent connected with Sonarqube.
- Run unit test using Buidkite agent with npm, executing npm test.
- Build a Docker container with Buildkite build number variable which is used to increments build version with each new build.
- Tag the final artifact with Build Number and as the latest version
- Deploy the code in the Env using K8s.sh which create/update the Kubernetes deployment and service for the app
- Release the recent built container images to the k8s cluster

All the development going to work in feature / dev branches, for every commit push build is going to trigger a build in Buildkite and deploy to the dev environment.
Test environment pipeline going to configured to run on master / develop branch, all the features going to merge to develop using pull requests.
Upon a successful deployment into the test environment, the deployment can be pushed to production with a click of a button manually.

Finally there are a few common goals that all CI/CD should share, in particularly:
- Build code only once (this ensures consistent build across environment)
- Deploy should be the same to every environment (other than environment variables)
- A broken deployment should never impact production.

## Kubernetes

A Simple Kubernetes layer has been added, required namespace, service, and deployment configs been added to this application for reference. When a build is being deployed by CI, the specific version determined by build number $ECR:$BN.


## Risks / Security

- The API does not have a logging setup which means it is hard to debug the - individual API calls in the application.
- The API does not have any monitoring configured.
- Currently the API is served over http which is a big risk in terms of production deploy.
- It does not have any authentication / authorisation support.
- Docker image is not being scanned for vulnerabilities.
- No rules define for who and how you can merge/push to the master branch.
