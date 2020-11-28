# hugo-webhook
Docker compose project to host static Hugo pages with automatic update refresh using webhooks.

Build the Dockerfile using the following command:
```
docker-compose build --build-arg SSH_PRIVATE_KEY="$(cat private.key)"
```

The private key will be used to pull the git repository. If your repo is public you could edit the Dockerfile to just pull over HTTPS.
Note: In order to get the key in the right format in the docker container you might need to replace the newlines in the private key-file with '/n'.

Start the docker containers with the following command:
```
docker compose up
```

Webhook will be reachable on http://127.0.0.1/hooks/refresh. The Hugo pages itself will be hosted on http://127.0.0.1. Configure your git repo to call the webhook URL on a push event.
