# kubernetes-action

Generate a Kubeconfig or creating or updating K8s Deployments. This action is a wrapper around the [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) command line tool to make it easier to use in a [GitHub Action](https://github.com/features/actions).

This thing is built using [Golang](https://go.dev) and [deploy-k8s](https://github.com/appleboy/deploy-k8s). 🚀

## Input variables

See [action.yml](./action.yml) for more detailed information.

| Parameter       | Description                                               | Required | Default Value |
|-----------------|-----------------------------------------------------------|----------|---------------|
| server          | Address of the Kubernetes cluster                          | true     |               |
| skip_tls_verify | Skip validity check for server certificate                |          | false         |
| ca_cert         | PEM-encoded certificate authority certificates            |          |               |
| token           | Kubernetes service account token                           | true     |               |
| namespace       | Kubernetes namespace                                       |          |               |
| proxy_url       | URLs with http, https, and socks5                          |          |               |
| templates       | Templates to render, supports glob pattern                 |          |               |
| cluster_name    | Cluster name                                              |          | default       |
| authinfo_name   | AuthInfo name                                              |          | default       |
| context_name    | Context name                                               |          | default       |
| debug           | Enable debug mode                                          |          | false         |
