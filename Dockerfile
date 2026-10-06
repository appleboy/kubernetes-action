FROM ghcr.io/appleboy/deploy-k8s:0.1.1@sha256:417c56c9a8bd43e0a43e1807a88614dd77a03933bf49d5975894db019d54090d

# GitHub Docker actions need root to access the mounted workspace.
USER root

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
