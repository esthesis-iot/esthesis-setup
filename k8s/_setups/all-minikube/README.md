#

## Prerequisites
* A minikube running
* Credentials for the private docker registry from which private images will be pulled:
    ```
    kubectl create secret docker-registry esthesis-dockerhub --docker-username=<your-name> --docker-password=<your-pword> --docker-email=<your-email>
    ```