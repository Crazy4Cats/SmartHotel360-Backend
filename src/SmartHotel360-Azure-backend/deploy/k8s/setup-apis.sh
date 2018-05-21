echo "------------------------------------------------------------"
echo "Logging into the registry ${ACR_NAME}"
echo "------------------------------------------------------------"
az acr create -n ${ACR_NAME} -g ${AKS_RG} --admin-enabled --sku Basic
az acr login -n ${ACR_NAME}

echo "------------------------------------------------------------"
echo "Applying PostgreSQL databases"
echo "------------------------------------------------------------"
kubectl apply -f postgres.yaml

echo "------------------------------------------------------------"
echo "Applying SQL Server databases"
echo "------------------------------------------------------------"
kubectl apply -f sql-data.yaml

echo "------------------------------------------------------------"
echo "Building and pushing to ACR"
echo "------------------------------------------------------------"
bash ./build-push.sh ${ACR_NAME}.azurecr.io

echo "------------------------------------------------------------"
echo "Deploying the code"
echo "------------------------------------------------------------"
bash ./deploy.sh ${ACR_NAME}.azurecr.io

echo "------------------------------------------------------------"
echo "Opening the dashboard"
echo "------------------------------------------------------------"
az aks browse -n ${AKS_NAME} -g ${AKS_RG}