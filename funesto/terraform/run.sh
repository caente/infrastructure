#!/bin/sh

REGION="us-east-1"
SERVICE_NAME=$1
SERVICE_TAG=$2
COMMAND=$3
ECR_REPO_URL="553846985037.dkr.ecr.${REGION}.amazonaws.com/${SERVICE_NAME}"

if [ "${COMMAND}" = "build" ]; then
  echo "Building ${SERVICE_NAME}:${SERVICE_TAG}..."
  cd ..
  sbt "${SERVICE_NAME}"/Universal/packageBin
elif [ "${COMMAND}" = "dockerize" ]; then
  echo "Dockerizing ${SERVICE_NAME}:${SERVICE_TAG}..."
  cd 4-service
  rm "${SERVICE_NAME}".zip
  cp ../../"${SERVICE_NAME}"/target/universal/"${SERVICE_NAME}".zip .
  # shellcheck disable=SC2091
  $(aws ecr get-login --no-include-email --region ${REGION} --profile dimeder)
  aws ecr create-repository --region ${REGION} --repository-name "${SERVICE_NAME:?}" --profile dimeder || true
  docker build --build-arg SERVICE_NAME="${SERVICE_NAME}" -t "${SERVICE_NAME}":"${SERVICE_TAG}"   .
  docker tag "${SERVICE_NAME}":"${SERVICE_TAG}" "${ECR_REPO_URL}":"${SERVICE_TAG}"
  docker push "${ECR_REPO_URL}":"${SERVICE_TAG}"
elif [ "${COMMAND}" = "plan" ]; then
  cd 4-service
  terraform init --backend-config="service-prod.config"
  terraform plan --var-file="production.tfvars" -var "docker_image_url=${ECR_REPO_URL}:${SERVICE_TAG}"
elif [ "${COMMAND}" = "deploy" ]; then
  cd 4-service
  echo "Deploying ${SERVICE_NAME}:${SERVICE_TAG}..."
  terraform init --backend-config="service-prod.config" -backend-config="key=PROD/${SERVICE_NAME}.tfstate" -reconfigure
  terraform apply --var-file="production.tfvars" -var "ecs_service_name=${SERVICE_NAME}" -var "docker_image_url=${ECR_REPO_URL}:${SERVICE_TAG}" --auto-approve
elif [ "${COMMAND}" = "destroy" ]; then
  cd 4-service
  echo "Destroying ${SERVICE_NAME}..."
  terraform init --backend-config="service-prod.config" -backend-config="key=PROD/${SERVICE_NAME}.tfstate" -reconfigure
  terraform destroy --var-file="production.tfvars" -var "ecs_service_name=${SERVICE_NAME}" -var "docker_image_url=${ECR_REPO_URL}:${SERVICE_TAG}" --auto-approve
fi
