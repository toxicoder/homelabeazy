# AppFlowy Helm Chart

This chart deploys AppFlowy, an open-source alternative to Notion.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.2.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
helm install my-release .
```

## Configuration

The following table lists the configurable parameters of the AppFlowy chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas to deploy. | `1` |
| `image.repository` | Image repository. | `ubuntu` |
| `image.pullPolicy` | Image pull policy. | `IfNotPresent` |
| `image.tag` | Image tag. | `latest` |
| `initContainer.image.repository` | Init container image repository. | `busybox` |
| `initContainer.image.tag` | Init container image tag. | `latest` |
| `initContainer.appflowy.version` | AppFlowy version to install. | `0.9.5` |
| `initContainer.appflowy.os` | AppFlowy OS. | `unknown-linux-gnu` |
| `initContainer.appflowy.arch` | AppFlowy architecture. | `x86_64` |
| `initContainer.appflowy.distro` | AppFlowy distribution. | `ubuntu-20.04` |
| `service.type` | Service type. | `ClusterIP` |
| `service.port` | Service port. | `8080` |
| `ingress.enabled` | Enable ingress. | `false` |
| `ingress.className` | Ingress class name. | `""` |
| `ingress.hosts` | Ingress hosts. | `[]` |
| `ingress.tls` | Ingress TLS configuration. | `[]` |
| `resources` | Resources limits and requests. | `{}` |
| `autoscaling.enabled` | Enable autoscaling. | `false` |
| `nodeSelector` | Node selector. | `{}` |
| `tolerations` | Tolerations. | `[]` |
| `affinity` | Affinity. | `{}` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
helm install my-release -f values.yaml .
```
