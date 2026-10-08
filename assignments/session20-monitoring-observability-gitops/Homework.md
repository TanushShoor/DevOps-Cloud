# Session 20 - Monitoring, Observability & GitOps Homework

# Task 1: Monitoring

Folder: [09-monitoring-demo/](09-monitoring-demo/)

I built on the Prometheus + Grafana compose from the session:

| File | What it does |
|---|---|
| [docker-compose.yml](09-monitoring-demo/docker-compose.yml) | Prometheus, node-exporter (host CPU/memory), Grafana |
| [prometheus.yml](09-monitoring-demo/prometheus.yml) | scrapes prometheus, node-exporter, grafana every 5s and loads the alert rules |
| [alert-rules.yml](09-monitoring-demo/alert-rules.yml) | `TargetDown` (up == 0), `HighCpuUsage` (> 80%), `HighMemoryUsage` (> 80%) |
| [grafana/provisioning/](09-monitoring-demo/grafana/provisioning/) | Prometheus datasource + dashboard auto-loaded at startup |

```bash
cd 09-monitoring-demo
docker compose up -d
```

**Metrics, CPU, memory, application health**

All 3 targets report `up`. CPU and memory are derived with PromQL from the node-exporter metrics. An `up` value of 1 means the app responded to the scrape, so it serves as the health check.

![](screenshots/01-metrics-cpu-memory.png)

**Alerts and logs**

I stopped node-exporter to take a target down. `up` dropped to 0 and after 15s the `TargetDown` alert moved to **firing**. Once I started it back up, `up` returned to 1 with no active alerts. The container logs are inspected using `docker logs`.

![](screenshots/02-alert-logs.png)

**Grafana dashboard** (http://localhost:3000) - CPU %, memory %, target health and request rate. The slight dip in the `node` tile comes from the alert test above.

![](screenshots/03-grafana-dashboard.png)

# Task 2: Observability

[observability/README.md](observability/README.md) - metrics, logs and traces, why observability matters, common tools and Kubernetes observability.

# Task 3: GitOps

Notes: [gitops/README.md](gitops/README.md) - what GitOps is, Git as the source of truth, declarative config, continuous reconciliation, the workflow, and Kubernetes + GitOps.

**Demo** using Argo CD on minikube with the [08-mini-project](08-mini-project/) manifests.

GitOps repo: https://github.com/ShivaGupta-14/session20-gitops

```text
session20-gitops/
└── app/
    ├── namespace.yaml
    ├── deployment.yaml   # replicas: 2 at the start, changed to 3 in step 2
    └── service.yaml
```

[argocd-application.yaml](08-mini-project/app/argocd-application.yaml) references this repo (`path: app`, `automated` with `prune` and `selfHeal`). It lives outside the repo path so Argo CD doesn't end up managing its own Application.

```bash
minikube start -p s20 --cpus=4 --memory=4096
kubectl create namespace argocd
kubectl apply -n argocd --server-side -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f 08-mini-project/app/argocd-application.yaml
```

**1. Argo CD running and app synced from Git** - Argo CD created the namespace, deployment (2 replicas) and service straight from the repo. The status reads `Synced` and `Healthy`.

![](screenshots/04-argocd-sync.png)

**2. Change through Git (replicas 2 -> 3)** - I edited only the YAML in Git and pushed, with no `kubectl` touching the deployment. I annotated the app with a refresh so it wouldn't wait on the 3 min poll. Argo CD synced the new commit `e146c44` and the deployment moved to 3/3.

![](screenshots/05-gitops-replicas-change.png)

**3. Self-healing (continuous reconciliation)** - I manually scaled it down to 1 to introduce drift. Because Git still declares 3 and `selfHeal: true`, Argo CD restored it to 3 within about 3 seconds (see the events: 3 -> 1 then 1 -> 3).

![](screenshots/06-argocd-self-heal.png)

```text
Git (replicas: 3)  = desired state
Kubernetes         = actual state
Argo CD            = compares and reconciles
```
