# Setting up esthesis platform

# Platofrm installation
```
 REGISTRY=docker-registry.local.nassosmichas.com envsubst < platform/esthesis-platform-server.yaml | kubectl apply -f -
 ```
 ```
 REGISTRY=docker-registry.local.nassosmichas.com envsubst < platform/esthesis-platform-ui.yaml | kubectl apply -f -
 ```