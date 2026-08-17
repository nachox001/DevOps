# Docker + Kubernetes Microservices Lab

A hands-on DevOps lab covering containerisation with Docker, multi-container workloads with Docker Compose, and orchestration with Kubernetes using kind.

## What this project demonstrates

- Building a custom Docker image from a Dockerfile
- Running and troubleshooting containers
- Port publishing and container lifecycle management
- Docker Compose for multi-container applications
- Docker service discovery and bridge networking
- Persistent Redis storage with a named volume
- Local Kubernetes cluster creation with kind
- Kubernetes Deployments, ReplicaSets and Pods
- Horizontal scaling with multiple replicas
- Self-healing by recreating deleted pods
- ClusterIP Services and Kubernetes DNS
- Frontend/backend microservices separation
- ConfigMap-based Nginx configuration
- Nginx reverse proxying from frontend `/api` to backend Service
- Temporary external access with `kubectl port-forward`

## Architecture

```text
Windows Browser
      |
      | port-forward
      v
Frontend Service
      |
      v
Frontend Deployment (2 replicas)
      |
      | /api -> http://backend
      v
Backend Service
      |
      +--> Backend Pod
      +--> Backend Pod
      +--> Backend Pod
      +--> Backend Pod
```

The frontend communicates with the backend using the Kubernetes DNS name `backend` rather than hard-coded Pod IP addresses.

## Project structure

```text
docker-kubernetes-microservices-lab/
├── docker/
│   ├── Dockerfile
│   └── index.html
├── compose/
│   └── compose.yaml
├── kubernetes/
│   ├── backend.yaml
│   ├── frontend.yaml
│   ├── frontend-configmap.yaml
│   └── nginx.conf
├── README.md
└── .gitignore
```

## Docker lab

Build the image:

```bash
cd docker
docker build -t david-nginx-lab:v1 .
```

Run the container:

```bash
docker run -d --name web-lab -p 8080:80 david-nginx-lab:v1
```

Inspect:

```bash
docker ps
docker logs web-lab
```

Test:

```bash
curl http://localhost:8080
```

## Docker Compose lab

```bash
cd compose
docker compose up -d
docker compose ps
```

The Compose stack contains:

- Nginx web service on host port `8081`
- Redis service on the internal Compose network
- Named volume `redis-data` mounted at `/data`

Test service discovery:

```bash
docker compose exec web ping -c 4 redis
docker compose exec web getent hosts redis
```

Test Redis persistence:

```bash
docker compose exec redis redis-cli SET interview "docker-compose"
docker compose exec redis redis-cli GET interview
```

## Kubernetes lab

This project was tested with a local kind cluster.

Create a cluster:

```bash
kind create cluster --name devops-lab
kubectl get nodes
```

Deploy the backend:

```bash
kubectl apply -f kubernetes/backend.yaml
```

Deploy the frontend configuration and workload:

```bash
kubectl apply -f kubernetes/frontend-configmap.yaml
kubectl apply -f kubernetes/frontend.yaml
```

Verify:

```bash
kubectl get deployments
kubectl get pods
kubectl get services
```

## Service discovery

The frontend reaches the backend through the stable Service name:

```text
http://backend
```

Test directly from the frontend:

```bash
kubectl exec deployment/frontend -- wget -qO- http://localhost/api
```

Expected response:

```text
Hello from the backend microservice
```

## Scaling

The backend manifest declares four replicas. It can also be scaled manually:

```bash
kubectl scale deployment backend --replicas=6
kubectl get pods -l app=backend
```

The `backend` Service remains unchanged while Kubernetes adjusts the number of backend Pods.

## Self-healing

Delete a backend Pod:

```bash
kubectl delete pod <backend-pod-name>
kubectl get pods -w
```

The Deployment/ReplicaSet controller creates a replacement Pod to restore the desired replica count.

## Browser access for the local lab

For a temporary local test:

```bash
kubectl port-forward --address <LAB_VM_IP> service/frontend 8083:80
```

Then browse to:

```text
http://<LAB_VM_IP>:8083
http://<LAB_VM_IP>:8083/api
```

`kubectl port-forward` is intended for development and troubleshooting; production workloads would normally use an appropriate Service type and/or Ingress.

## Key learning concepts

**Docker image vs container:** an image is the packaged template; a container is an instance created from that image.

**Docker vs Compose:** Docker manages individual containers; Compose declaratively manages a related multi-container application.

**Deployment:** declares the desired state for an application workload and manages ReplicaSets/Pods.

**Service:** provides a stable endpoint and service discovery for ephemeral Pods.

**Scaling:** replicas can increase or decrease independently for different microservices.

**Self-healing:** Kubernetes continuously reconciles actual state with desired state.

**ConfigMap:** separates non-secret configuration from the container image and injects it into Pods.

