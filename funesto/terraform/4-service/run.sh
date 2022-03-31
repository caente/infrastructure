#!/bin/sh

REGION="us-east-1"
SERVICE_NAME="server"
SERVICE_TAG="v7"
ECR_REPO_URL="553846985037.dkr.ecr.${REGION}.amazonaws.com/${SERVICE_NAME}"

if [ "$1" = "build" ]; then
  echo "Building application..."
  cd ../..
  sbt Universal/packageBin
elif [ "$1" = "dockerize" ]; then
  echo "Dockerizing application..."
  rm ${SERVICE_NAME}.zip
  cp ../../target/universal/${SERVICE_NAME}.zip .
  # shellcheck disable=SC2091
  $(aws ecr get-login --no-include-email --region ${REGION} --profile dimeder)
  aws ecr create-repository --region ${REGION} --repository-name ${SERVICE_NAME:?} --profile dimeder || true
  docker build -t ${SERVICE_NAME}:${SERVICE_TAG} .
  docker tag ${SERVICE_NAME}:${SERVICE_TAG} ${ECR_REPO_URL}:${SERVICE_TAG}
  docker push ${ECR_REPO_URL}:${SERVICE_TAG}
elif [ "$1" = "plan" ]; then
  terraform init --backend-config="service-prod.config"
  terraform plan --var-file="production.tfvars" -var "docker_image_url=${ECR_REPO_URL}:${SERVICE_TAG}"
elif [ "$1" = "deploy" ]; then
  terraform init --backend-config="service-prod.config"
  terraform apply --var-file="production.tfvars" -var "docker_image_url=${ECR_REPO_URL}:${SERVICE_TAG}" --auto-approve
elif [ "$1" = "destroy" ]; then
  terraform init --backend-config="service-prod.config"
  terraform destroy --var-file="production.tfvars" -var "docker_image_url=${ECR_REPO_URL}:${SERVICE_TAG}" --auto-approve
fi
