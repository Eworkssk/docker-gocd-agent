FROM gocd/gocd-agent-ubuntu-22.04:v22.3.0

ARG DEBIAN_FRONTEND=noninteractive

ENV PHP_VERSION 8.1
ENV NODE_VERSION 16
ENV NVM_VERSION 0.39.2

# Install nvm
SHELL ["/bin/bash", "--login", "-i", "-c"]
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v$NVM_VERSION/install.sh | bash
SHELL ["/bin/bash", "--login", "-c"]

# Install node.js
RUN nvm install $NODE_VERSION

# Install node.js runner
USER root
ADD node.sh /usr/bin/xnode
RUN chmod 777 /usr/bin/xnode

# Install PHP
RUN apt update -y && apt install -y php$PHP_VERSION-cli

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

USER go


