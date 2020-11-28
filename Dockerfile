FROM ubuntu

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt install hugo webhook -y

# Authorize SSH Host
RUN mkdir -p /root/.ssh && \
    chmod 0700 /root/.ssh && \
    ssh-keyscan github.com > /root/.ssh/known_hosts

# Add ssh private key into container
ARG SSH_PRIVATE_KEY

# Add the key and set permissions
RUN echo ${SSH_PRIVATE_KEY} > /root/.ssh/id_rsa && \
    chmod 600 /root/.ssh/id_rsa

RUN git clone git@github.com:<repository> /var/www/html/Documentation

RUN cd /var/www/html/Documentation/ && hugo

RUN chown -R www-data:www-data /var/www/html/Documentation/public

RUN echo '#!/bin/bash \ncd /var/www/html/Documentation/ && git pull && hugo' > update.sh && chmod +x update.sh

COPY hooks.json /etc/hooks.json

# Expose default webhook port
EXPOSE 9000

#ENTRYPOINT [ "/usr/bin/supervisord", "-c", "/etc/supervisord.conf" ]
ENTRYPOINT ["/usr/bin/webhook", "-hooks", "/etc/hooks.json"]
