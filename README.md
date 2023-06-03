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

### Update Deployment

To update a deployment, you can use the following configuration:

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

In the above configuration, the `appleboy/kubernetes-action` action is used to update the deployment. Here's an explanation of the provided parameters:

* **server**: The URL or IP address of the Kubernetes API server.
* **ca_cert**: The CA certificate used to authenticate the Kubernetes API server.
* **token**: The token used for authentication to the Kubernetes API server.
* **namespace**: The namespace where the deployment is located.
* **templates**: The path to the deployment file ([deployment01.yaml](./example/deployment01.yaml)) that contains the updated configuration.

Make sure to replace the placeholders (`${{ secrets.K8S_SERVER }}`, `${{ secrets.K8S_CA_CERT }}`, and `${{ secrets.K8S_TOKEN }}`) with the appropriate values or secrets from your environment or repository settings.

By executing this action, the specified deployment file will be used to update the existing deployment in the specified namespace.

### Deploy Deployment with Custom Variables

To use custom variables in the template, refer to the following deployment file:

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

In the above file, you can see the use of `{{ .envs.app_name }}` variable. To add environment variables, you need to specify a prefix containing `INPUT_`.

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

By adding the env section and specifying `INPUT_APP_NAME: nginx`, you can pass the value of nginx to the `{{ .envs.app_name }}` variable in the deployment file.

Please note that this assumes you are using a deployment script or workflow that supports environment variables and can replace the placeholders with their corresponding values during deployment.
