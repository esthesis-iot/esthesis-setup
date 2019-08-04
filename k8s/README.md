# Setting up esthesis platform

This section of the documentation provides you Kubernetes configurations to setup an esthesis platform.
As esthesis comprises of several different parts, you may want all of them or some of them. All available
configurations are divided into different files, so that you can pick the ones you need in your
specific environment.

## Prerequisites
* A Kubernetes environment >= 1.15
* A shell with [envsubst](https://www.gnu.org/software/gettext/manual/html_node/envsubst-Invocation.html)
* A Docker hub account for esthesis.
    * To allow Kubernetes to pull from the private Docker registry you should create a resource for the
    credentials of the registry:
    ```
    kubectl create secret docker-registry esthesis-docker-registry --docker-server=docker.io \
        --docker-username=<your-name> --docker-password=<your-pword> --docker-email=<your-email>
    ```

## Configuration resources
The esthesis configurations/deployments for Kubernetes are grouped into several categories as presented next.
If case you have no special persistent volume provisioner in your environment, you can use the `standard` class.

### Platform
Contains the configurations to deploy the two main artifacts of esthesis platform.

#### esthesis-platform-ui.yaml
The frontend component of esthesis platform.

```
kubectl apply -f platform/esthesis-platform-ui.yaml
```
Substitute `REGISTRY` with the location of the Docker Registry hosting the `esthesis-platform-server` container.

#### esthesis-platform-server.yaml
The backend component of esthesis platform.

```
STORAGECLASS=your-storageclass \
envsubst < platform/esthesis-platform-server.yaml | kubectl apply -f -
```

### Data sinks
Data sinks are optional components, providing targets on which esthesis can persist telemetry and metadata data.
We provide convenience configuration resource for the data sinks currently supported in esthesis.

#### esthesis-ds-influxdb.yaml
An instance of InfluxDB to be used as a data sink.

```
STORAGECLASS=your-storageclass \
envsubst < datasinks/esthesis-ds-influxdb.yaml | kubectl apply -f -
```

#### esthesis-ds-mysql.yaml
An instance of MySQL to be used as data sink.

```
STORAGECLASS=your-storageclass \
envsubst < datasinks/esthesis-ds-mysql.yaml | kubectl apply -f -
```  

### Platform services
Platform services provide configurations for components which are necessary for the esthesis platform to operate.
Currently, a MySQL database is only necessary, so you can create it from the components configurations provided
here or use one you have prepared.

```
STORAGECLASS=your-storageclass \
envsubst < platform-services/esthesis-ps-db.yaml | kubectl apply -f -
```

### Monitors
For many resources you may find a `*-monitor.yaml` alongside the resource. These are resources for which
an administration/browsing resource is also available. Monitoring resources are not necessary for the 
correct operation of esthesis platform, however provide you a quick and easy way to be able to monitor
the underlying services.

#### esthesis-ds-influxdb-monitor.yaml
A Chrongraf frontend for InfluxDB data sink.
```
kubectl apply -f datasinks/esthesis-ds-influxdb-monitor.yaml
```

#### esthesis-ds-mysql-monitor.yaml
A phpMyAdmin frontend for MySQL data sink.
```
kubectl apply -f datasinks/esthesis-ds-mysql-monitor.yaml
```

#### esthesis-ps-db-monitor.yaml
A phpMyAdmin frontend for esthesis platform's main MySQL database.
```
kubectl apply -f platform-services/esthesis-ps-db-monitor.yaml
```

### Backup
All database-related resources come with an optional `*-backup.yaml` resource configuration. 
This is a container based on [tiredofit/db-backup](https://hub.docker.com/r/tiredofit/db-backup)
which allows you to take automatic backups at predefined intervals.

#### esthesis-ds-influxdb-backup.yaml
A backup container for the InfluxDB data sink.
```
STORAGECLASS=your-storageclass \
envsubst < datasinks/esthesis-ds-influxdb-backup.yaml | kubectl apply -f -
```


### Make-all environment
You can create an environment with all resources issuing just a single command:
```
STORAGECLASS=your-storageclass \
bash -c 'for f in $(find . -name "*.yaml"); do envsubst < $f | kubectl apply -f -; done'
```

Mind you that if you run the above on an empty cluster it might take some time (5-10') before
all resources are properly deployed. Just let K8s do its job and restart pods until everything
is up and running.

### Dev environment on Minikube
#### Volumes
When booting up dev environments on Minikube, you can use the `standard` storage class. In that case,
your PVs are creted under `/tmp/hostpath-provisioner` on the Minikube machine.
#### Exposing services to your development machine
You can expose services running in pods to your local machine via:
```
minikube port-forward {name-of-pod} local-port:pod-port
```

For example, if you have an nginx pod named "nginx-ab345i" exposing port 80, you can forward this 
port to your development machine on port 8080 by executing:
```
minikube port-forward nginx-ab345i 8080:80
```
And you can access it via http://localhost:8080.