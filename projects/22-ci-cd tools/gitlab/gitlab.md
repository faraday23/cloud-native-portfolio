<!DOCTYPE html>
<html>
<head>
  <title>.gitlab-ci.yml Configuration</title>
</head>
<body>
  <h1>GitLab CI/CD Configuration</h1>
  <p>My task was to implement a CI/CD pipeline for the application using GitLab. The pipeline had to support automated builds, tests, code quality checks, containerization, and deployments to different environments.</p>

  <h2>Step 1:</h2>
  <p>Create a <code>.gitlab-ci.yml</code> file in the root directory of your monorepo. This file will define the pipeline configuration for all the microservices in the monorepo. You can use the <code>include</code> keyword to reference other YAML files that contain common settings or scripts for your pipeline stages. For example, you can have a <code>build.yml</code> file that defines the build stage for all the microservices, and include it in your <code>.gitlab-ci.yml</code> file as follows:</p>
  <pre><code class="language-yaml">
include:
  - local: build.yml
  </code></pre>

  <h2>Step 2:</h2>
  <p>In your <code>.gitlab-ci.yml</code> file, define the pipeline triggers for your microservices. You can use the <code>rules</code> keyword to specify when to run the pipeline based on the branch, tag, event or other conditions. For example, you can have a rule that triggers the pipeline only when there is a push or merge request event on the main branch as follows:</p>
  <pre><code class="language-yaml">
rules:
  - if: '$CI_PIPELINE_SOURCE == "push" || $CI_PIPELINE_SOURCE == "merge_request_event"'
    when: always
    changes:
      - services/**/*
  </code></pre>
  <p>The <code>changes</code> keyword allows you to specify which files or directories should trigger the pipeline. In this case, we use the <code>services/**/*</code> pattern to match any file or directory under the <code>services</code> directory, which is where we assume our microservices are located.</p>

  <h2>Step 3:</h2>
  <p>In your <code>.gitlab-ci.yml</code> file, define the pipeline stages for your microservices. You can use the <code>stages</code> keyword to list the names of the stages in the order they should run. For example, you can have the following stages:</p>
  <pre><code class="language-yaml">
stages:
  - build
  - test
  - package
  - deploy
  </code></pre>

  <h2>Step 4:</h2>
  <p>In your <code>.gitlab-ci.yml</code> file, define the jobs for each stage and each microservice. You can use the <code>jobs</code> keyword to name and configure each job. For example, you can have a job that builds and tests the <code>service-a</code> microservice as follows:</p>
  <pre><code class="language-yaml">
service-a-build-test:
  stage: build
  image: php:7.4-cli
  script:
    - cd services/service-a
    - composer install --no-interaction --prefer-dist --no-progress --no-suggest
    - ./vendor/bin/phpunit --coverage-text --colors=never
  artifacts:
    paths:
      - services/service-a/vendor
      - services/service-a/composer.lock
    expire_in: 1 week
  cache:
    key: service-a-${CI_COMMIT_REF_SLUG}
    paths:
      - services/service-a/vendor
  </code></pre>
  <p>The <code>stage</code> keyword specifies which stage this job belongs to. The <code>image</code> keyword specifies which Docker image to use for running this job. The <code>script</code> keyword specifies the commands to run for this job. The <code>artifacts</code> keyword specifies which files or directories to save and pass to the next stage. The <code>cache</code> keyword specifies which files or directories to cache and reuse between pipeline runs.</p>

  <h2>Step 5:</h2>
  <p>Repeat step 4 for each stage and each microservice. For example, you can have a job that runs code quality checks for the <code>service-a</code> microservice as follows:</p>
  <pre><code class="language-yaml">
service-a-code-quality:
  stage: test
  image: php:7.4-cli
  script:
    - cd services/service-a
    - ./vendor/bin/phpcs --standard=PSR12 src tests
    - ./vendor/bin/phpstan analyse src tests --level=max
  needs:
    - service-a-build-test
  </code></pre>
  <p>The <code>needs</code> keyword specifies which jobs this job depends on and should run after.</p>

  <h2>Step 6:</h2>
  <p>In your <code>.gitlab-ci.yml</code> file, define a job that builds and pushes Docker images for each microservice to GitLab Container Registry. You can use the <code>docker:dind</code> service to enable Docker commands in your job. You can also use the predefined variables <code>$CI_REGISTRY</code>, <code>$CI_REGISTRY_IMAGE</code>, <code>$CI_COMMIT_REF_SLUG</code>, and <code>$CI_COMMIT_SHORT_SHA</code> to construct the image name and tag. For example, you can have a job that builds and pushes the <code>service-a</code> image as follows:</p>
  <pre><code class="language-yaml">
service-a-package:
  stage: package
  image: docker:19.03.12
  services:
    - docker:dind
  script:
    - cd services/service-a
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - docker build -t $CI_REGISTRY_IMAGE/service-a:$CI_COMMIT_REF_SLUG-$CI_COMMIT_SHORT_SHA .
    - docker push $CI_REGISTRY_IMAGE/service-a:$CI_COMMIT_REF_SLUG-$CI_COMMIT_SHORT_SHA
  needs:
    - service-a-build-test
  </code></pre>

  <h2>Step 7:</h2>
  <p>In your <code>.gitlab-ci.yml</code> file, define a job that deploys the Docker images to Kubernetes clusters using GitLab Kubernetes integration. You can use the <code>kubectl</code> command to apply the Kubernetes manifests for your microservices. You can also use the predefined variables <code>$KUBE_NAMESPACE</code> and <code>$CI_ENVIRONMENT_SLUG</code> to set the namespace and environment name for your deployment. For example, you can have a job that deploys the <code>service-a</code> image as follows:</p>
  <pre><code class="language-yaml">
service-a-deploy:
  stage: deploy
  image: bitnami/kubectl:latest
  script:
    - kubectl apply -f services/service-a/k8s/service.yaml -n $KUBE_NAMESPACE
    - kubectl set image deployment/service-a service-a=$CI_REGISTRY_IMAGE/service-a:$CI_COMMIT_REF_SLUG

-$CI_COMMIT_SHORT_SHA -n $KUBE_NAMESPACE
  environment:
    name: $CI_ENVIRONMENT_SLUG
    url: http://service-a.$KUBE_NAMESPACE.svc.cluster.local
  needs:
    - service-a-package
  </code></pre>
</body>
</html>