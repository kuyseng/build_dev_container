FROM ubuntu:18.04

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8


# Download script and run it with the option above
RUN apt-get update -qq && export DEBIAN_FRONTEND=noninteractive  \
  && apt-get -y install --no-install-recommends curl ca-certificates \
  && bash -c "$(curl -fsSL 'https://raw.githubusercontent.com/microsoft/vscode-dev-containers/main/script-library/common-debian.sh')" -- "true" "automatic" "automatic" "automatic" "false" \
  && apt-get clean -y && rm -rf /var/lib/apt/lists/*
# install docker & docker-compose
RUN apt-get update -qq && export DEBIAN_FRONTEND=noninteractive \
  && bash -c "$(curl -fsSL 'https://raw.githubusercontent.com/microsoft/vscode-dev-containers/main/script-library/docker-in-docker-debian.sh')" -- "true" "automatic" "false" "latest" "v2" \
  && apt-get clean -y && rm -rf /var/lib/apt/lists/*
# install ruby
RUN apt-get update -qq && export DEBIAN_FRONTEND=noninteractive \
  && bash -c "$(curl -fsSL 'https://raw.githubusercontent.com/microsoft/vscode-dev-containers/main/script-library/ruby-debian.sh')" -- "2.3.1" \
  && apt-get clean -y && rm -rf /var/lib/apt/lists/*
# install nodejs
RUN apt-get update -qq && export DEBIAN_FRONTEND=noninteractive \
  && bash -c "$(curl -fsSL 'https://raw.githubusercontent.com/microsoft/vscode-dev-containers/main/script-library/node-debian.sh')" -- "/usr/local/share/nvm" "16.19.0" \
  && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# project requirement
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  zlib1g-dev build-essential libssl-dev libreadline-dev \
  libyaml-dev libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev dirmngr gnupg \
  apt-transport-https ca-certificates wget openssh-server nodejs \
  libpq-dev \
  libexif-dev \
  mariadb-client libmariadbclient-dev \
  imagemagick libmagickcore-dev libmagickwand-dev \
  qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x \
  && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# other
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  vim tmux iputils-ping \
  && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# update zsh themes & plugins
RUN sed -i 's/codespaces/aussiegeek/' /root/.zshrc && \
    sed -i 's/codespaces/aussiegeek/' /home/vscode/.zshrc && \
    sed -i 's/(git)/(git rails rake docker docker-compose)/' /root/.zshrc && \
    sed -i 's/(git)/(git rails rake docker docker-compose)/' /home/vscode/.zshrc

# customize dev container plugin
LABEL devcontainer.metadata='[{"postCreateCommand": "[[ -f Gemfile ]] &&  bundle check && bundle install" },"customizations":{"vscode":{"extensions":["eamodio.gitlens","ms-azuretools.vscode-docker","misogi.ruby-rubocop"]}}]'
