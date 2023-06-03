# kubernetes-action

[![deploy kubernetes](https://github.com/appleboy/kubernetes-action/actions/workflows/deploy.yml/badge.svg?branch=main)](https://github.com/appleboy/kubernetes-action/actions/workflows/deploy.yml)
[![kubectl command](https://github.com/appleboy/kubernetes-action/actions/workflows/kubectl.yml/badge.svg?branch=main)](https://github.com/appleboy/kubernetes-action/actions/workflows/kubectl.yml)

The Kubernetes Action Tool is a versatile tool that facilitates interactions with Kubernetes clusters. This action is a wrapper around the [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) command line tool to make it easier to use in a [GitHub Action](https://github.com/features/actions).

With this Kubernetes Action Tool, you can perform various operations and configurations on Kubernetes clusters by leveraging these parameters. Whether it's updating deployments, managing containers, generating kubeconfig files, or performing other Kubernetes-related tasks, this tool provides flexibility and control over your cluster operations.

This thing is built using [Golang](https://go.dev) and [deploy-k8s](https://github.com/appleboy/deploy-k8s). 🚀

## Input variables

See [action.yml](./action.yml) for more detailed information.

| Parameter        | Description                                                  | Required | Default Value |
| ---------------- | ------------------------------------------------------------ | -------- | ------------- |
| `server`         | Address of the Kubernetes cluster                            | `true`   | -             |
| `skip_tls_verify`| Skip validity check for server certificate (default: `false`) | -        | `false`       |
| `ca_cert`        | PEM-encoded certificate authority certificates              | -        | -             |
| `token`          | Kubernetes service account token                             | `true`   | -             |
| `namespace`      | Kubernetes namespace                                         | -        | -             |
| `proxy_url`      | URLs with http, https, and socks5 proxies                    | -        | -             |
| `templates`      | Templates to render, supports glob pattern                   | -        | -             |
| `cluster_name`   | Cluster name (default: "default")                            | -        | `default`     |
| `authinfo_name`  | AuthInfo name (default: "default")                           | -        | `default`     |
| `context_name`   | Context name (default: "default")                            | -        | `default`     |
| `deployment`     | Name of the Kubernetes deployment to update                  | -        | -             |
| `container`      | Name of the container within the deployment to update        | -        | -             |
| `image`          | New image and tag for the container                          | -        | -             |
| `output`         | Output kubeconfig to file                                    | -        | -             |
| `debug`          | Enable debug mode (default: `false`)                         | -        | `false`       |

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

## Update Deployment Container Image

To update a deployment container image, you can use the following configuration:

```diff
  - name: Update deployment
    uses: appleboy/kubernetes-action@master
    with:
      server: ${{ secrets.K8S_SERVER }}
      ca_cert: ${{ secrets.K8S_CA_CERT }}
      token: ${{ secrets.K8S_TOKEN }}
      namespace: github-action
+     deployment: nginx
+     container: nginx
+     image: nginx:1.24.0
```

In the above configuration, the appleboy/kubernetes-action action is used to update the deployment's container image. Here's an explanation of the added parameters:

* **deployment**: The name of the deployment to update.
* **container**: The name of the container within the deployment to update.
* **image**: The new image and tag that you want to use for the container.

Make sure to replace the placeholder values (`${{ secrets.K8S_SERVER }}`, `${{ secrets.K8S_CA_CERT }}`, and `${{ secrets.K8S_TOKEN }}`) with the appropriate values or secrets from your environment or repository settings. Similarly, replace nginx with the actual names of your deployment and container.

By executing this action, the specified deployment's container image will be updated to the specified version, allowing you to roll out new changes or upgrades to your application.

### Generate Kubeconfig file

To generate a kubeconfig file and use it for subsequent Kubernetes operations, you can follow this configuration:

```diff
  - name: generate kubeconfig
    uses: ./
    with:
      server: ${{ secrets.K8S_SERVER }}
      ca_cert: ${{ secrets.K8S_CA_CERT }}
      token: ${{ secrets.K8S_TOKEN }}
+     output: kubeconfig.yaml

  - name: get pods in github-action namespace
    env:
+     KUBECONFIG: kubeconfig.yaml
    run: |
      sudo chmod 644 kubeconfig.yaml
      kubectl get pods -n github-action
```

In the above configuration, the kubeconfig file is generated using the specified parameters for server address, certificate authority (CA) certificate, and token. Here's an explanation of the added parameter:

* **output**: Specifies the output file name for the generated kubeconfig file. In this example, it is set to `kubeconfig.yaml`.

After generating the kubeconfig file, it can be used to authenticate subsequent `kubectl` commands. In the next step, the `KUBECONFIG` environment variable is set to the generated kubeconfig file path (`kubeconfig.yaml`). This ensures that kubectl uses the generated kubeconfig file for authentication when running the command kubectl get pods -n github-action.

Please note that the sudo chmod 644 kubeconfig.yaml command is included to set the appropriate permissions for the kubeconfig file, allowing it to be readable by the user running the command.

By following this configuration, you can generate a kubeconfig file and use it to perform Kubernetes operations within the specified namespace.
