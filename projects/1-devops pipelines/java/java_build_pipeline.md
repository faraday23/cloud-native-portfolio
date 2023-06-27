
<head>
  <h1>Problem-Solving and Automation in Software Project Management</h1>
</head>
<body>
  <header>
    <h1>Situation:</h1>
  </header>
  <p>The situation involved a project that was facing erratic build failures, causing delays and inefficiency in the software development lifecycle. The inconsistent build environment was affecting the project deadline, and it was imperative for us to stabilize the build process.</p>

  <header>
    <h1>Task:</h1>
  </header>
  <p>My task, as a software engineer, was to diagnose the source of these failures and devise an efficient, reproducible Maven build script that would ensure consistent project builds.</p>

  <header>
    <h1>Action:</h1>
  </header>
  <p>I developed the Bash script provided above. The script begins by setting the necessary environment variables for Maven. Project-specific variables were subsequently declared, and previous builds are removed to avoid conflicts. Depending on the specified build mode, the script then either compiles the project or packages it; it also performs necessary test validation. Upon successful build, the script installs the newly created artifacts to the local Maven repository. It subsequently generates various test reports, with the build process repeating itself automatically.</p>

  <header>
    <h1>Result:</h1>
  </header>
  <p>The script was successfully integrated into the project's existing CI/CD pipeline. With its implementation, the project build became more stable, significantly reducing the previously faced random build failures. As a result, the team was able to consistently progress according to the project timeline with failures almost nullified. The solution improved the efficiency of the development process and increased the overall code quality with consistent and reliable testing.</p>

  <header>
    <p>The above presentation is a demonstration of problem-solving and automation applied in real-world software project management scenarios, showcasing the importance of a scripting language like Bash in facilitating efficient software development.</p>
  </header>
</body>






<body>
  <header>
    <h1>Job Definition for "build" in YAML:</h1>
  </header>
  <p>This YAML file defines a job named "build" that runs on every push to the "main" branch of the repository. The job runs on an Ubuntu machine and consists of several steps.</p>

  <header>
    <h2>Steps:</h2>
  </header>
  <ol>
    <li>
      <p>The first step checks out the source code using the "actions/checkout" action.</p>
    </li>
    <li>
      <p>The second step sets up JDK 11 using the "actions/setup-java" action.</p>
    </li>
    <li>
      <p>The third step installs Maven by downloading the binary distribution, extracting it, and setting the environment variables.</p>
    </li>
    <li>
      <p>The fourth step is the main build step, which uses Maven to build the project. The build mode is determined by the "build_mode" variable in the "matrix" section. The build script is the same as the one in the bash script you provided.</p>
    </li>
    <li>
      <p>The fifth step generates the unit test report if the build mode is "debug", using the "mvn surefire-report:report" command.</p>
    </li>
    <li>
      <p>The sixth step generates the integration test report if the build mode is "debug", using the "mvn failsafe-report:report" command.</p>
    </li>
    <li>
      <p>The seventh step generates the acceptance test report if the build mode is "debug", using the "mvn serenity:aggregate" command.</p>
    </li>
    <li>
      <p>The eighth step installs the artifacts to the local Maven repository if the build mode is "release", using the "mvn..." command.</p>
    </li>
  </ol>
</body>



```yaml
name: Java Build and Test

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v2
      
    - name: Set up JDK 11
      uses: actions/setup-java@v2
      with:
        java-version: '11'
    
    - name: Install Maven
      run: |
        wget https://apache.osuosl.org/maven/maven-3/3.8.4/binaries/apache-maven-3.8.4-bin.tar.gz
        tar xzf apache-maven-3.8.4-bin.tar.gz
        export MAVEN_HOME=$PWD/apache-maven-3.8.4
        export PATH=$MAVEN_HOME/bin:$PATH
    
    - name: Build with Maven
      run: |
        if [ "${{ matrix.build_mode }}" = "debug" ]; then
          mvn validate
          mvn clean compile test integration-test -DskipITs=false -DskipTests=false
        else
          mvn validate
          mvn clean package
        fi
      env:
        MAVEN_OPTS: "-Xmx2048m"
      strategy:
        matrix:
          build_mode: [ release, debug ]
    
    - name: Generate Unit Test Report
      if: matrix.build_mode == 'debug'
      run: |
        mvn surefire-report:report
    
    - name: Generate Integration Test Report
      if: matrix.build_mode == 'debug'
      run: |
        mvn failsafe-report:report
    
    - name: Generate Acceptance Test Report
      if: matrix.build_mode == 'debug'
      run: |
        mvn serenity:aggregate
    
    - name: Install Artifacts
      run: |
        mvn install:install-file -Dfile=target/$PROJECT_NAME-$PROJECT_VERSION.jar -DgroupId=com.example -DartifactId=$PROJECT_NAME -Dversion=$PROJECT_VERSION -Dpackaging=jar
      if: matrix.build_mode == 'release'
    
    - name: Check Installation Status
      run: |
        if [ $? -ne 0 ]; then
          echo "Artifact installation failed"
          exit 1
        fi
      if: matrix.build_mode == 'release'
```


```shell
#!/bin/bash

# Set environment variables
export MAVEN_HOME=/opt/maven
export PATH=$PATH:$MAVEN_HOME/bin

# Set project variables
PROJECT_NAME=my-project
PROJECT_VERSION=1.0.0
BUILD_MODE=release

# Clean up previous builds
rm -rf build/

# Build project
if [ "$BUILD_MODE" = "debug" ]; then
  mvn validate
  mvn clean compile test integration-test -DskipITs=false -DskipTests=false
else
  mvn validate
  mvn clean package
fi

# Check build status
if [ $? -ne 0 ]; then
  echo "Build failed"
  exit 1
fi

# Install artifacts to local Maven repository
mvn install:install-file -Dfile=target/$PROJECT_NAME-$PROJECT_VERSION.jar -DgroupId=com.example -DartifactId=$PROJECT_NAME -Dversion=$PROJECT_VERSION -Dpackaging=jar

# Check installation status
if [ $? -ne 0 ]; then
  echo "Artifact installation failed"
  exit 1
fi

# Generate unit test report
mvn surefire-report:report

# Generate integration test report
mvn failsafe-report:report

# Generate acceptance test report
mvn serenity:aggregate

echo "Build and installation complete"
```


```xml
<project>
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.example</groupId>
  <artifactId>my-app</artifactId>
  <version>1.0-SNAPSHOT</version>
  <name>My App</name>
  <description>My awesome Java application</description>

  <dependencies>
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>4.12</version>
      <scope>test</scope>
    </dependency>
  </dependencies>

  <build>
    <sourceDirectory>src/main/java</sourceDirectory>
    <outputDirectory>target/classes</outputDirectory>
    <plugins>
      <!-- Use an existing Maven plugin to generate code -->
      <plugin>
        <groupId>org.codehaus.mojo</groupId>
        <artifactId>jaxb2-maven-plugin</artifactId>
        <version>2.5.0</version>
        <executions>
          <execution>
            <id>xjc</id>
            <goals>
              <goal>xjc</goal>
            </goals>
            <configuration>
              <schemaDirectory>src/main/resources</schemaDirectory>
              <outputDirectory>src/main/java</outputDirectory>
            </configuration>
          </execution>
        </executions>
      </plugin>

      <!-- Create a custom Maven plugin to process data files -->
      <plugin>
        <groupId>com.example</groupId>
        <artifactId>data-processing-plugin</artifactId>
        <version>1.0-SNAPSHOT</version>
        <executions>
          <execution>
            <id>process-data-files</id>
            <goals>
              <goal>process-data</goal>
            </goals>
            <configuration>
              <inputDirectory>src/main/data</inputDirectory>
              <outputDirectory>target/data</outputDirectory>
            </configuration>
          </execution>
        </executions>
      </plugin>

      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-compiler-plugin</artifactId>
        <version>3.8.1</version>
        <configuration>
          <source>1.8</source>
          <target>1.8</target>
        </configuration>
      </plugin>
    </plugins>
  </build>
</project>
```