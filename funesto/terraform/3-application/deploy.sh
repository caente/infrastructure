#!/usr/bin/sh

echo $HOME
SERVICE_NAME="funesto"
SERVICE_TAG="v1"
ECR_REPO_URL="553846985037.dkr.ecr.us-east-1.amazonaws.com/${SERVICE_NAME}"

if [ "$1" = "build" ]; then
  echo "Building application..."
  cd ../..
  sbt assembly
elif [ "$1" = "dockerize" ]; then
  echo "Dockerizing application..."
  cp ../../target/scala-2.13/${SERVICE_NAME}.jar .
  # shellcheck disable=SC2091
  $(aws ecr get-login --no-include-email --region us-east-1 --profile dimeder )
  aws ecr create-repository --region us-east-1 --repository-name ${SERVICE_NAME:?} --profile dimeder || true
  docker build -t ${SERVICE_NAME}:${SERVICE_TAG} .
  docker tag ${SERVICE_NAME}:${SERVICE_TAG} ${ECR_REPO_URL}:${SERVICE_TAG}
  docker push ${ECR_REPO_URL}:${SERVICE_TAG}
elif [ "$1" = "plan" ]; then
  terraform init --backend-config="app-prod.config"
  terraform plan --var-file="production.tfvars" -var "docker_image_url=${ECR_REPO_URL}:${SERVICE_NAME}"
elif [ "$1" = "deploy" ]; then
  terraform init --backend-config="app-prod.config"
  terraform taint --allow-missing aws_ecs_task_definition.app-definition
  terraform apply --var-file="production.tfvars" -var "docker_image_url=${ECR_REPO_URL}:${SERVICE_NAME}" --auto-approve
elif [ "$1" = "destroy" ]; then
  terraform init --backend-config="app-prod.config"
  terraform destroy --var-file="production.tfvars" -var "docker_image_url=${ECR_REPO_URL}:${SERVICE_NAME}" --auto-approve
fi
