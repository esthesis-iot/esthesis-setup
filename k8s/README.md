# Setting up esthesis platform

This section of the documentation provides you Kubernetes configurations to setup an esthesis platform.
As esthesis comprises of several different parts, you may want all of them or some of them. All available
configurations are divided into different files, so that you can pick the ones you need in your
specific environment.

## Prerequisites
* A Kubernetes environment >= 1.15
* A shell with [envsubst](https://www.gnu.org/software/gettext/manual/html_node/envsubst-Invocation.html)

## Configuration resources
The esthesis configurations/deployments for Kubernetes are grouped into several categories as presented next.
Most resources, require you to define the Docker Registry from which Docker images are pulled as well as the
Storage Class from which Kubernetes will provide you a persistent volume. If case you have no special
persistent volume provisioner in your environment, you can use the `standard` class.

### Platform
Contains the configurations to deploy the two main artifacts of esthesis platform.

#### esthesis-platform-ui.yaml
The frontend component of esthesis platform.

```
REGISTRY=your-registry \
envsubst < platform/esthesis-platform-ui.yaml | kubectl apply -f -
```
Substitute `REGISTRY` with the location of the Docker Registry hosting the `esthesis-platform-server` container.

#### esthesis-platform-server.yaml
The backend component of esthesis platform.

```
REGISTRY=your-registry \
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

### Make-all environment
You can create an environment with all resources issuing just a single command:
```
REGISTRY=esthesis-registry \
STORAGECLASS=your-storageclass \
bash -c 'for f in $(find . -name "*.yaml"); do envsubst < $f | kubectl apply -f -; done'
```

### Dev environment on Minikube and volumes
When booting up dev environments on Minikube, you can use the `standard` storage class. In that case,
your PVs are creted under `/tmp/hostpath-provisioner` on the Minikube machine.