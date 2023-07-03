  <h1>Task:</h1>
  <p>My task was to implement a CI/CD pipeline for the application using GitHub Actions. The pipeline had to support automated builds, tests, code quality checks, containerization, and deployments to different environments.</p>

```yaml
name: Java CI

on:
  push:
    branches: [ master ]
  pull_request:
    branches: [ master ]

jobs:
  build_and_scan:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        java-version: ['11', '12', '13', '14']

    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Set up JDK
        uses: actions/setup-java@v2
        with:
          java-version: ${{ matrix.java-version }}
          distribution: 'adopt'

      - name: Cache Maven packages
        uses: actions/cache@v2
        with:
          path: ~/.m2
          key: ${{ runner.os }}-m2-${{ hashFiles('**/pom.xml') }}
          restore-keys: ${{ runner.os }}-m2

      - name: Set up Maven
        run: |
          echo "MAVEN_OPTS='-Xmx3072m'" > $GITHUB_ENV
          echo "MAVEN_USER_HOME=$(pwd)/.m2" > $GITHUB_ENV

      - name: Clean install with Maven
        run: mvn -B clean install --file pom.xml

      - name: Run Checkstyle
        if: contains(github.event.head_commit.message, '[ci java]')
        run: mvn checkstyle:checkstyle

      - name: SonarCloud Scan
        if: contains(github.event.head_commit.message, '[ci java]')
        uses: SonarSource/sonarcloud-github-action@master
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}

      - name: Login to DockerHub
        if: github.repository == 'YOUR_USERNAME/YOUR_REPOSITORY'
        uses: docker/login-action@v1
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Build and push
        id: docker_build
        uses: docker/build-push-action@v2
        with:
          context: .
          push: true
          cache-from: type=local,src=/tmp/.buildx-cache
          cache-to: type=local,dest=/tmp/.buildx-cache
          cache-from: type=gha
          cache-to: type=gha,mode=max

      - name: Scan image
        run: |
          docker pull ${{ steps.docker_build.outputs.docker_image_digest }}
          docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy ${ steps.docker_build.outputs.docker_image_digest }}
        id: scan
        continue-on-error: true

      - name: Fail on vulnerability detected
        run: exit 1
        if: steps.scan.outcome == 'failure'

  helm_and_argocd_deploy:
    needs: build_and_scan
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Setup Helm
        uses: azure/setup-helm@v1
        with:
          version: 'v3.7.0'

      - name: Build Helm chart
        run: |
          echo "appVersion: ${GITHUB_SHA}" >> ./helm/Chart.yaml
          helm package ./helm

      - name: Tag Helm chart
        run: |
          helm chart save my-chart:${GITHUB_SHA} my-chart/

      - name: Push Helm chart
        run: |
          echo ${CR_PAT} | helm registry login ghcr.io -u USERNAME --password-stdin
          helm chart push my-chart:${GITHUB_SHA}
        env:
          CR_PAT: ${{ secrets.CR_PAT }}

      - name: ArgoCD Login
        run: |
          argocd login argocd.example.com --username ${{ secrets.ARGOCD_USER }} --password ${{ secrets.ARGOCD_PASSWORD }} --insecure

      - name: Update ArgoCD App
        run: |
          argocd app set MY_APP -p image.tag=${{ github.sha }}

      - name: Sync ArgoCD App
        run: |
          argocd app sync MY_APP

      - name: Check ArgoCD App Health
        id: health_check
        run: |
          if ! argocd app health MY_APP --timeout 60s; then
            echo "Deployment failed."
            exit 1
          fi

      - name: Rollback ArgoCD App
        if: failure() && steps.health_check.outcome == 'failure'
        run: |
          argocd app rollback MY_APP

      - name: Capture Failure Events
        if: failure() && steps.health_check.outcome == 'failure'
        run: |
          argocd app events MY_APP
```
