# kubernetes-action

[![deploy kubernetes](https://github.com/appleboy/kubernetes-action/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/appleboy/kubernetes-action/actions/workflows/ci.yml)

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

## Usage

### deploy deployment without variable

Update deployment. See the [deployment file](./example/deployment01.yaml)

```yaml
- name: Update deployment
  uses: appleboy/kubernetes-action@master
  with:
    server: ${{ secrets.K8S_SERVER }}
    ca_cert: ${{ secrets.K8S_CA_CERT }}
    token: ${{ secrets.K8S_TOKEN }}
    namespace: github-action
    templates: example/deployment01.yaml
```

### deploy deployment with custom variable

Use custom variabe in template. See the following deployment file:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .envs.app_name }}
  namespace: github-action
  labels:
    app: {{ .envs.app_name }}
spec:
  selector:
    matchLabels:
      app: {{ .envs.app_name }}
  template:
    metadata:
      name: {{ .envs.app_name }}
      labels:
        app: {{ .envs.app_name }}
    spec:
      containers:
        - name: nginx
          image: nginx:1.25.0
          imagePullPolicy: IfNotPresent
          ports:
            - name: http
              containerPort: 80
          resources:
            requests:
              memory: "64Mi"
              cpu: "250m"
            limits:
              memory: "128Mi"
              cpu: "500m"
```

See the `{{ .envs.app_name }}` variable and add environment variables by specifying a prefix containing `INPUT_`.

```diff
  - name: deploy by variable
    uses: ./
+   env:
+     INPUT_APP_NAME: nginx
    with:
      server: ${{ secrets.K8S_SERVER }}
      ca_cert: ${{ secrets.K8S_CA_CERT }}
      token: ${{ secrets.K8S_TOKEN }}
      namespace: github-action
      templates: example/deployment02.yaml
```
