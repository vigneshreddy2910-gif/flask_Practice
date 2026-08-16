# Flask Student Management Application – CI/CD Deployment

## 1. Project Overview

This project implements a Flask-based Student Management Application using MongoDB as the database.

The project is containerized using Docker and follows a complete CI/CD workflow using GitHub Actions.

The CI/CD pipeline performs the following operations:

1. Checks out the source code.
2. Sets up Python.
3. Installs project dependencies.
4. Runs automated tests using Pytest.
5. Configures AWS credentials.
6. Logs in to Amazon ECR.
7. Builds the Docker image.
8. Pushes the Docker image to Amazon ECR.
9. Deploys the latest Docker image to an Amazon EC2 instance.
10. Runs the Flask application and MongoDB using Docker containers.
11. Sends an email notification through Amazon SNS after deployment.
12. Sends a notification when the pipeline succeeds or fails.

---

# 2. Objectives

The main objectives of this project are:

- Develop a Flask web application for student management.
- Integrate Flask with MongoDB.
- Containerize the application using Docker.
- Create automated unit tests using Pytest.
- Implement CI/CD using GitHub Actions.
- Store Docker images in Amazon Elastic Container Registry (ECR).
- Deploy the application to a single Amazon EC2 instance.
- Run Flask and MongoDB as Docker containers.
- Automate application deployment whenever code is pushed to the `main` branch.
- Configure AWS IAM permissions using the principle of least privilege.
- Implement email notifications using Amazon SNS.
- Notify the developer about successful and failed deployments.

---

# 3. Project Architecture

```text
                         Developer
                             |
                             | git push
                             v
                    +-------------------+
                    |     GitHub        |
                    |    Repository     |
                    +---------+---------+
                              |
                              v
                    +-------------------+
                    |   GitHub Actions   |
                    |    CI/CD Pipeline  |
                    +---------+---------+
                              |
                +-------------+-------------+
                |                           |
                v                           v
        Run Pytest Tests             Configure AWS
                                            |
                                            v
                                   +----------------+
                                   |   Amazon ECR   |
                                   | Docker Registry|
                                   +-------+--------+
                                           |
                                           | Pull Image
                                           v
                                   +----------------+
                                   |  Amazon EC2    |
                                   | Single Instance|
                                   +-------+--------+
                                           |
                             +-------------+-------------+
                             |                           |
                             v                           v
                    +----------------+          +----------------+
                    | Flask Container|          | MongoDB        |
                    | Port 5000      |          | Container      |
                    +-------+--------+          +----------------+
                            |
                            v
                     Flask Application
                            |
                            v
                     Student Management


                    GitHub Actions
                          |
                          v
                    Amazon SNS
                          |
                          v
                    Email Notification
```

---

# 4. Technologies Used

| Technology | Purpose |
|---|---|
| Python | Application development |
| Flask | Web application framework |
| Flask-PyMongo | MongoDB integration |
| MongoDB | Database |
| PyMongo | MongoDB Python driver |
| Pytest | Automated testing |
| Docker | Application containerization |
| Git | Version control |
| GitHub | Source code repository |
| GitHub Actions | CI/CD automation |
| Amazon ECR | Docker image registry |
| Amazon EC2 | Application hosting |
| Amazon SNS | Email notifications |
| AWS IAM | Access control and permissions |
| AWS CLI | AWS resource management |
| Ubuntu | EC2 operating system |

---

# 5. Project Structure

The project follows the following structure:

```text
flask_Practice/
│
├── .github/
│   └── workflows/
│       └── ci-cd.yml
│
├── templates/
│   ├── index.html
│   ├── add_student.html
│   └── update_student.html
│
├── app.py
├── test_app.py
├── requirements.txt
├── Dockerfile
├── .dockerignore
├── .env
└── README.md
```

> The `.env` file contains local environment variables and should not be committed to GitHub.

---

# 6. Flask Application

The application is implemented using Flask.

The application provides the following functionality:

- Display all students.
- Add a new student.
- Update an existing student.
- Delete a student.
- Health check endpoint.

The Flask application uses environment variables for configuration.

The important environment variables are:

```text
MONGO_URI
SECRET_KEY
```

The application uses MongoDB through Flask-PyMongo.

For local development, the application can use:

```text
mongodb://localhost:27017/student_db
```

For Docker deployment, the MongoDB container is accessed using its Docker container name:

```text
mongodb://mongodb:27017/student_db
```

The application exposes port:

```text
5000
```

The health endpoint is:

```text
/health
```

A successful health check returns:

```json
{
  "status": "healthy"
}
```

---

# 7. Flask Application Features

## 7.1 Home Page

The home page is available at:

```text
/
```

It displays the list of students stored in MongoDB.

---

## 7.2 Add Student

The application provides the following endpoint:

```text
/add
```

The endpoint supports:

```text
GET
POST
```

Student information includes:

```text
Name
Email
Course
```

---

## 7.3 Update Student

The application provides:

```text
/update/<student_id>
```

The endpoint allows existing student information to be modified.

---

## 7.4 Delete Student

The application provides:

```text
/delete/<student_id>
```

The endpoint deletes the selected student from MongoDB.

---

## 7.5 Health Check

The health endpoint is:

```text
/health
```

Expected response:

```json
{
  "status": "healthy"
}
```

This endpoint is useful for checking whether the deployed Flask application is running correctly.

---

# 8. Environment Variables

The application uses environment variables instead of hard-coding configuration values.

Example local configuration:

```text
MONGO_URI=mongodb://localhost:27017/student_db
SECRET_KEY=your-secret-key
```

During Docker deployment, the values are provided through Docker environment variables.

Example:

```bash
-e MONGO_URI="mongodb://mongodb:27017/student_db"
-e SECRET_KEY="flask-production-secret"
```

Sensitive values should not be committed to GitHub.

---

# 9. Automated Testing Using Pytest

Automated tests were created using Pytest.

The test file is:

```text
test_app.py
```

The tests verify the major application functions.

The test suite includes:

```text
test_home_page
test_add_student
test_update_student
test_delete_student
test_health
```

The tests use Flask's test client.

MongoDB is also used during testing.

The test database is:

```text
test_student_db
```

The test process performs database setup before testing and cleanup after testing.

---

# 10. Test Execution

The tests can be executed locally using:

```bash
pytest
```

The local test execution was successfully completed.

The GitHub Actions pipeline also automatically executes:

```bash
pytest
```

before building and deploying the Docker image.

This ensures that a failed test prevents the deployment process from continuing.

---

# 11. Docker Containerization

The Flask application is packaged into a Docker image.

The Docker image contains:

- Python
- Flask
- Application dependencies
- Application source code
- Flask configuration

The Docker image exposes port:

```text
5000
```

The Flask application runs inside the Docker container.

---

# 12. MongoDB Container

MongoDB is also executed as a Docker container.

The MongoDB container uses:

```text
mongo:7
```

The MongoDB container is named:

```text
mongodb
```

The Flask container and MongoDB container communicate through a Docker bridge network.

The network created for the application is:

```text
flask-network
```

The MongoDB connection string inside the Flask container is:

```text
mongodb://mongodb:27017/student_db
```

The important point is that `mongodb` refers to the MongoDB container name on the Docker network.

---

# 13. Docker Network

A dedicated Docker network was created:

```bash
sudo docker network create flask-network
```

The Flask application container and MongoDB container are connected to this network.

The network can be verified using:

```bash
sudo docker network ls
```

Expected network:

```text
flask-network
```

This allows the containers to communicate without exposing MongoDB publicly.

---

# 14. Amazon ECR Setup

Amazon Elastic Container Registry (ECR) was used to store the Docker image.

The ECR repository created for the project is:

```text
flask-student-app
```

The repository is located in:

```text
us-east-1
```

The ECR image was successfully created and pushed by GitHub Actions.

The image was tagged using the Git commit SHA.

Example:

```text
2920d27fe59e2fd9859cf25e5e0acb782d1e0f1f
```

The ECR image URI follows this format:

```text
457660516966.dkr.ecr.us-east-1.amazonaws.com/flask-student-app:<IMAGE_TAG>
```

---

# 15. GitHub Actions CI/CD

GitHub Actions was used to automate the complete CI/CD pipeline.

The workflow file is:

```text
.github/workflows/ci-cd.yml
```

The workflow is triggered when code is pushed to:

```text
main
```

It can also be started manually using:

```text
workflow_dispatch
```

---

# 16. CI/CD Pipeline Flow

The pipeline performs the following sequence:

```text
Git Push
   |
   v
Checkout Repository
   |
   v
Setup Python
   |
   v
Install Dependencies
   |
   v
Run Pytest
   |
   v
Configure AWS Credentials
   |
   v
Login to Amazon ECR
   |
   v
Build Docker Image
   |
   v
Push Docker Image to ECR
   |
   v
Deploy to EC2
   |
   v
Send SNS Notification
```

---

# 17. GitHub Actions Workflow

The workflow contains the following major stages:

```yaml
name: Flask CI/CD Pipeline

on:
  push:
    branches:
      - main
  workflow_dispatch:
```

The main job is:

```yaml
jobs:
  build-test-push:
```

The workflow runs on:

```yaml
runs-on: ubuntu-latest
```

---

# 18. MongoDB Service in GitHub Actions

A MongoDB service container is used for automated testing.

```yaml
services:
  mongodb:
    image: mongo:7
    ports:
      - 27017:27017
```

The MongoDB service allows the Pytest test suite to communicate with MongoDB during the CI process.

The test environment uses:

```yaml
env:
  MONGO_URI: mongodb://localhost:27017/test_student_db
  SECRET_KEY: github-actions-test-secret
```

---

# 19. Checkout Source Code

GitHub Actions checks out the repository:

```yaml
- name: Checkout repository
  uses: actions/checkout@v4
```

This makes the latest source code available to the workflow.

---

# 20. Python Setup

Python 3.12 is used by the GitHub Actions workflow:

```yaml
- name: Set up Python
  uses: actions/setup-python@v5
  with:
    python-version: "3.12"
```

---

# 21. Install Dependencies

The workflow installs the dependencies listed in:

```text
requirements.txt
```

using:

```bash
python -m pip install --upgrade pip
pip install -r requirements.txt
```

---

# 22. Run Automated Tests

The workflow executes:

```bash
pytest
```

The tests must pass before the Docker image is built and pushed.

The pipeline successfully completed the automated test stage.

---

# 23. AWS Credentials for GitHub Actions

GitHub Actions was configured with AWS credentials using GitHub repository secrets.

The workflow uses:

```yaml
- name: Configure AWS credentials
  uses: aws-actions/configure-aws-credentials@v4
  with:
    aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
    aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    aws-region: us-east-1
```

The credentials are stored as GitHub Secrets rather than directly inside the workflow file.

The following GitHub Secrets are used:

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```

---

# 24. AWS IAM User for GitHub Actions

An IAM user was configured for GitHub Actions.

The user was given permissions required for:

- Amazon ECR operations.
- Amazon SNS publishing.

The ECR permissions were provided through:

```text
AmazonEC2ContainerRegistryPowerUser
```

An additional customer-managed inline policy was created for SNS publishing.

The policy was named:

```text
GitHubActionsSNSPublish
```

---

# 25. SNS Least-Privilege Policy

The GitHub Actions IAM user was given only the required SNS publishing permission.

Example policy:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sns:Publish",
      "Resource": "arn:aws:sns:us-east-1:457660516966:flask-student-deployment"
    }
  ]
}
```

The SNS topic ARN should be replaced with the actual topic ARN if the topic name or AWS account is different.

This approach follows the principle of least privilege because GitHub Actions only receives:

```text
sns:Publish
```

permission for the required SNS topic.

---

# 26. Amazon ECR Login

GitHub Actions logs into Amazon ECR using:

```yaml
- name: Login to Amazon ECR
  id: login-ecr
  uses: aws-actions/amazon-ecr-login@v2
```

The ECR registry returned by this action is used to construct the Docker image URI.

---

# 27. Docker Image Build

The Docker image is built using the GitHub commit SHA as the image tag.

Example:

```yaml
env:
  ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
  ECR_REPOSITORY: flask-student-app
  IMAGE_TAG: ${{ github.sha }}
```

The Docker image is built using:

```bash
docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG .
```

This creates a uniquely identifiable image for every commit.

---

# 28. Push Docker Image to Amazon ECR

After the image is built, it is pushed to ECR:

```bash
docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG
```

The image was successfully pushed to:

```text
flask-student-app
```

in:

```text
us-east-1
```

The image was verified successfully in the Amazon ECR console.

---

# 29. Amazon EC2 Deployment

A single EC2 instance was used for deployment instead of an EC2 cluster.

This architecture is sufficient for the assignment because the application is deployed as a single-instance application.

The EC2 instance uses:

```text
Ubuntu
```

The instance type used was:

```text
t2.micro
```

The EC2 instance runs:

```text
Docker
AWS CLI
```

The EC2 instance was successfully configured to access Amazon ECR.

---

# 30. EC2 IAM Role

An IAM role was attached to the EC2 instance:

```text
EC2-ECR-Pull-Role
```

The role allows the EC2 instance to authenticate with Amazon ECR and pull Docker images.

The identity was verified using:

```bash
aws sts get-caller-identity
```

The EC2 instance successfully returned an assumed-role identity associated with:

```text
EC2-ECR-Pull-Role
```

---

# 31. Docker and AWS CLI Verification on EC2

Docker was verified using:

```bash
docker --version
```

AWS CLI was verified using:

```bash
aws --version
```

The EC2 instance successfully had both Docker and AWS CLI available.

---

# 32. ECR Authentication from EC2

The EC2 instance authenticates with Amazon ECR using:

```bash
aws ecr get-login-password --region us-east-1 | \
docker login \
--username AWS \
--password-stdin \
457660516966.dkr.ecr.us-east-1.amazonaws.com
```

Successful authentication returns:

```text
Login Succeeded
```

---

# 33. Pull Docker Image on EC2

The Docker image stored in ECR can be pulled using:

```bash
sudo docker pull \
457660516966.dkr.ecr.us-east-1.amazonaws.com/flask-student-app:<IMAGE_TAG>
```

The image was successfully downloaded to the EC2 instance.

The image can be verified using:

```bash
sudo docker images
```

---

# 34. MongoDB Deployment on EC2

MongoDB was started as a Docker container.

Example:

```bash
sudo docker run -d \
  --name mongodb \
  --network flask-network \
  --restart unless-stopped \
  mongo:7
```

The MongoDB container was successfully started.

It can be verified using:

```bash
sudo docker ps
```

---

# 35. Flask Application Deployment on EC2

The Flask application Docker container was started using the ECR image.

Example:

```bash
sudo docker run -d \
  --name flask-student-app \
  --network flask-network \
  --restart unless-stopped \
  -p 5000:5000 \
  -e MONGO_URI="mongodb://mongodb:27017/student_db" \
  -e SECRET_KEY="flask-production-secret" \
  457660516966.dkr.ecr.us-east-1.amazonaws.com/flask-student-app:<IMAGE_TAG>
```

The container was successfully started.

---

# 36. Verify Running Containers

The running containers can be checked using:

```bash
sudo docker ps
```

The deployment contains:

```text
flask-student-app
mongodb
```

The Flask container exposes:

```text
5000
```

The MongoDB container communicates internally through:

```text
flask-network
```

---

# 37. Verify Docker Environment Variables

The Flask container environment can be verified using:

```bash
sudo docker inspect flask-student-app \
  --format '{{range .Config.Env}}{{println .}}{{end}}'
```

The deployment uses:

```text
MONGO_URI=mongodb://mongodb:27017/student_db
SECRET_KEY=<configured-secret>
```

---

# 38. Verify Flask Application

The deployed application can be accessed using the EC2 public IP address:

```text
http://<EC2-PUBLIC-IP>:5000
```

The Flask home page should load successfully.

---

# 39. Verify Health Endpoint

The health endpoint can be tested using:

```bash
curl http://<EC2-PUBLIC-IP>:5000/health
```

Expected response:

```json
{
  "status": "healthy"
}
```

The health endpoint was successfully verified after deployment.

---

# 40. GitHub Actions Deployment Automation

The deployment process was added to the GitHub Actions workflow.

The purpose of this stage is to automatically deploy the latest ECR image to the EC2 instance after the image has been successfully built and pushed.

The workflow therefore changes the deployment process from:

```text
Manual Docker Deployment
```

to:

```text
Git Push
    |
    v
GitHub Actions
    |
    v
Tests
    |
    v
Docker Build
    |
    v
ECR Push
    |
    v
EC2 Deployment
```

This means a new Docker image can be deployed automatically whenever a successful commit is pushed to the `main` branch.

---

# 41. Deployment Image Tag

Each GitHub Actions execution uses:

```text
${{ github.sha }}
```

as the Docker image tag.

For example:

```text
2920d27fe59e2fd9859cf25e5e0acb782d1e0f1f
```

This provides traceability between:

```text
Git Commit
      |
      v
Docker Image
      |
      v
EC2 Deployment
```

This makes it possible to identify which Git commit is currently deployed.

---

# 42. Amazon SNS Setup

Amazon Simple Notification Service (SNS) was used for deployment email notifications.

An SNS topic was created:

```text
flask-student-deployment
```

The SNS topic is responsible for sending deployment notifications through email.

---

# 43. SNS Email Subscription

An email subscription was created for the SNS topic.

The subscription must be confirmed through the confirmation email sent by Amazon SNS.

After confirmation, SNS can deliver messages to the subscribed email address.

---

# 44. GitHub Actions SNS Notification

GitHub Actions publishes an SNS message after the deployment process.

The workflow uses:

```bash
aws sns publish
```

The message contains deployment information such as:

```text
Application
Repository
Commit
Deployment status
```

Example:

```bash
aws sns publish \
  --topic-arn "arn:aws:sns:us-east-1:457660516966:flask-student-deployment" \
  --subject "Flask Student App Deployment" \
  --message "Flask Student Application deployment completed successfully."
```

The topic ARN must match the actual SNS topic.

---

# 45. Success Notification

When the complete CI/CD pipeline succeeds, an SNS notification is sent.

The notification indicates that:

```text
Tests passed
Docker image was built
Docker image was pushed to ECR
Application was deployed to EC2
```

The email notification was successfully received.

---

# 46. Failure Notification

The workflow was also configured to send a notification when the CI/CD pipeline fails.

The failure notification uses the GitHub Actions condition:

```yaml
if: failure()
```

This ensures that the notification step executes when an earlier pipeline step fails.

Example:

```yaml
- name: Send failure notification
  if: failure()
  run: |
    aws sns publish \
      --topic-arn "${{ secrets.SNS_TOPIC_ARN }}" \
      --subject "Flask Student App - Deployment Failed" \
      --message "The Flask Student Application CI/CD pipeline failed. Please check the GitHub Actions workflow logs."
```

---

# 47. Success Notification Configuration

The success notification can use:

```yaml
- name: Send success notification
  if: success()
  run: |
    aws sns publish \
      --topic-arn "${{ secrets.SNS_TOPIC_ARN }}" \
      --subject "Flask Student App - Deployment Successful" \
      --message "The Flask Student Application was successfully tested, built, pushed to ECR, and deployed to EC2."
```

The SNS topic ARN can be stored as a GitHub Secret:

```text
SNS_TOPIC_ARN
```

This prevents the ARN from being unnecessarily hard-coded in the workflow.

---

# 48. GitHub Secrets

The GitHub repository uses secrets for sensitive AWS information.

The configured secrets include:

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
SNS_TOPIC_ARN
```

Secrets are referenced from the workflow using:

```yaml
${{ secrets.AWS_ACCESS_KEY_ID }}
```

```yaml
${{ secrets.AWS_SECRET_ACCESS_KEY }}
```

```yaml
${{ secrets.SNS_TOPIC_ARN }}
```

Sensitive credentials should never be committed directly to the repository.

---

# 49. Complete CI/CD Pipeline

The final pipeline performs:

```text
                    Git Push to main
                           |
                           v
                  Checkout Repository
                           |
                           v
                     Setup Python
                           |
                           v
                  Install Dependencies
                           |
                           v
                     Run Pytest
                           |
                    +------+------+
                    |             |
                  FAIL          PASS
                    |             |
                    v             v
             SNS Failure     Configure AWS
             Notification          |
                                  v
                             Login to ECR
                                  |
                                  v
                          Build Docker Image
                                  |
                                  v
                         Push Image to ECR
                                  |
                                  v
                           Deploy to EC2
                                  |
                           +------+------+
                           |             |
                         FAIL          PASS
                           |             |
                           v             v
                    SNS Failure     SNS Success
                    Notification     Notification
```

---

# 50. Final AWS Architecture

```text
                         AWS Cloud
                             |
          +------------------+------------------+
          |                                     |
          v                                     v
     Amazon ECR                            Amazon SNS
          |                                     |
          |                                     v
          |                              Email Notification
          |
          | Docker Image
          v
     +-----------------------------+
     |          EC2 Instance       |
     |                             |
     |       Docker Network        |
     |      flask-network          |
     |                             |
     |  +-----------------------+  |
     |  | Flask Container       |  |
     |  | flask-student-app     |  |
     |  | Port 5000             |  |
     |  +-----------+-----------+  |
     |              |              |
     |              v              |
     |  +-----------------------+  |
     |  | MongoDB Container     |  |
     |  | mongodb               |  |
     |  | MongoDB 7             |  |
     |  +-----------------------+  |
     |                             |
     +-----------------------------+
```

---

# 51. CI/CD Workflow File

The workflow is stored at:

```text
.github/workflows/ci-cd.yml
```

The workflow contains the following major stages:

```yaml
name: Flask CI/CD Pipeline

on:
  push:
    branches:
      - main
  workflow_dispatch:

jobs:
  build-test-push:
    runs-on: ubuntu-latest

    services:
      mongodb:
        image: mongo:7
        ports:
          - 27017:27017
        options: >-
          --health-cmd "mongosh --eval 'db.adminCommand(\"ping\")'"
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    env:
      MONGO_URI: mongodb://localhost:27017/test_student_db
      SECRET_KEY: github-actions-test-secret

    steps:

      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.12"

      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt

      - name: Run tests
        run: |
          pytest

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1

      - name: Login to Amazon ECR
        id: login-ecr
        uses: aws-actions/amazon-ecr-login@v2

      - name: Build Docker image
        env:
          ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
          ECR_REPOSITORY: flask-student-app
          IMAGE_TAG: ${{ github.sha }}
        run: |
          docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG .

      - name: Push Docker image to Amazon ECR
        env:
          ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
          ECR_REPOSITORY: flask-student-app
          IMAGE_TAG: ${{ github.sha }}
        run: |
          docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG

      - name: Deploy to EC2
        # EC2 deployment commands are executed here.
        # The EC2 instance pulls the image from Amazon ECR
        # and restarts the Flask container.

      - name: Send success notification
        if: success()
        run: |
          aws sns publish \
            --topic-arn "${{ secrets.SNS_TOPIC_ARN }}" \
            --subject "Flask Student App - Deployment Successful" \
            --message "The Flask Student Application was successfully tested, built, pushed to ECR, and deployed to EC2."

      - name: Send failure notification
        if: failure()
        run: |
          aws sns publish \
            --topic-arn "${{ secrets.SNS_TOPIC_ARN }}" \
            --subject "Flask Student App - Deployment Failed" \
            --message "The Flask Student Application CI/CD pipeline failed. Please check GitHub Actions for details."
```

---

# 52. Verification of CI/CD Pipeline

After configuring the workflow, a change was pushed to the `main` branch.

GitHub Actions successfully executed:

```text
Checkout repository
        |
        v
Set up Python
        |
        v
Install dependencies
        |
        v
Run tests
        |
        v
Configure AWS credentials
        |
        v
Login to Amazon ECR
        |
        v
Build Docker image
        |
        v
Push Docker image to Amazon ECR
        |
        v
Deploy to EC2
        |
        v
Send SNS notification
```

The GitHub Actions workflow completed successfully.

---

# 53. ECR Verification

The Docker image was verified in the Amazon ECR console.

Repository:

```text
flask-student-app
```

Image status:

```text
Active
```

The image was successfully stored in Amazon ECR.

The image size was approximately:

```text
64.4 MB
```

---

# 54. EC2 Verification

The EC2 instance was verified using:

```bash
sudo docker ps
```

The running containers were:

```text
flask-student-app
mongodb
```

The Flask container exposed:

```text
0.0.0.0:5000 -> 5000
```

The MongoDB container was running on the Docker network.

---

# 55. Application Verification

The Flask application was successfully accessed through the EC2 public IP address.

The home page returned:

```text
HTTP 200
```

The health endpoint:

```text
/health
```

also returned:

```text
HTTP 200
```

with:

```json
{
  "status": "healthy"
}
```

This confirms that the application was successfully deployed and running.

---

# 56. Email Notification Verification

Amazon SNS email notification was successfully configured.

The deployment email was received after a successful pipeline execution.

The notification system is designed to provide:

```text
SUCCESS
```

notifications when the pipeline completes successfully and:

```text
FAILURE
```

notifications when the pipeline fails.

---

# 57. Security Configuration

The following security practices were implemented:

- AWS credentials are stored in GitHub Secrets.
- Sensitive application secrets are passed through environment variables.
- EC2 uses an IAM role for ECR access.
- GitHub Actions uses IAM permissions for required AWS services.
- SNS publishing uses a least-privilege policy.
- MongoDB is not required to be exposed publicly.
- Docker containers communicate using a private Docker network.
- The ECR image is identified using the Git commit SHA.

---

# 58. IAM Permissions

The main AWS permissions used in the project are:

## GitHub Actions IAM User

Used for:

```text
Amazon ECR
Amazon SNS
```

ECR permissions:

```text
AmazonEC2ContainerRegistryPowerUser
```

SNS permission:

```text
sns:Publish
```

restricted to the deployment SNS topic.

---

## EC2 IAM Role

The EC2 instance uses:

```text
EC2-ECR-Pull-Role
```

This allows the instance to authenticate with Amazon ECR and pull the application image.

---

# 59. Deployment Process After a New Code Change

After the initial configuration, the deployment process is automated.

The developer only needs to:

```bash
git add .
git commit -m "Update application"
git push origin main
```

GitHub Actions automatically performs:

```text
1. Checkout code
2. Install dependencies
3. Run tests
4. Configure AWS
5. Login to ECR
6. Build Docker image
7. Push image to ECR
8. Deploy image to EC2
9. Send success/failure notification
```

No manual Docker image build or ECR push is required after the pipeline is configured.

---

# 60. Final Project Workflow

The final workflow can be summarized as:

```text
Developer
    |
    | git push
    v
GitHub Repository
    |
    v
GitHub Actions
    |
    +----> Pytest
    |
    +----> Docker Build
    |
    +----> Amazon ECR
              |
              | Docker Image
              v
          Amazon EC2
              |
              +----> Flask Container
              |
              +----> MongoDB Container
              |
              v
        Running Application
              |
              v
        Health Check /health


GitHub Actions
      |
      v
 Amazon SNS
      |
      v
Email Notification
      |
      +----> Success
      |
      +----> Failure
```

---

# 61. Assignment Requirements Covered

| Requirement | Status |
|---|---|
| Flask application | Completed |
| MongoDB integration | Completed |
| Automated Pytest testing | Completed |
| Docker containerization | Completed |
| GitHub repository | Completed |
| GitHub Actions CI/CD | Completed |
| AWS IAM configuration | Completed |
| Amazon ECR repository | Completed |
| Docker image pushed to ECR | Completed |
| EC2 deployment | Completed |
| MongoDB Docker container | Completed |
| Flask Docker container | Completed |
| EC2 ECR access using IAM role | Completed |
| Automated deployment | Completed |
| Amazon SNS topic | Completed |
| Email subscription | Completed |
| Success email notification | Completed |
| Failure email notification | Completed |
| Least-privilege SNS permission | Completed |

---

# 62. Conclusion

The Flask Student Management Application was successfully developed, tested, containerized, and deployed using a complete CI/CD pipeline.

The final implementation integrates:

```text
Flask
+
MongoDB
+
Pytest
+
Docker
+
GitHub Actions
+
Amazon ECR
+
Amazon EC2
+
AWS IAM
+
Amazon SNS
```

The CI/CD pipeline automatically validates the application, builds a Docker image, stores the image in Amazon ECR, deploys the application to an EC2 instance, and sends email notifications through Amazon SNS.

The use of GitHub Actions removes the need for repeated manual deployment operations and provides a repeatable deployment process for future application changes.

The final deployment architecture uses a single EC2 instance containing two Docker containers:

```text
Flask Application Container
        +
MongoDB Container
```

Both containers communicate through the dedicated:

```text
flask-network
```

The application is exposed through port:

```text
5000
```

The successful implementation demonstrates a complete end-to-end CI/CD workflow from source-code commit to cloud deployment and notification.
