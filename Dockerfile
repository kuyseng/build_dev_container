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


# our project need tzdata
RUN apt update -qq && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata \
  && apt-get clean -y && rm -rf /var/lib/apt/lists/*

## install postgresql-client
# https://www.postgresql.org/download/linux/ubuntu/
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' \
  && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && apt-get update && apt-get install -y --no-install-recommends postgresql-client-14 \
  && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# update zsh themes for vscode user
USER vscode
RUN mkdir /home/vscode/.ssh/
RUN sed -i 's/codespaces/aussiegeek/' /home/vscode/.zshrc && \
    sed -i 's/(git)/(git rails rake docker docker-compose)/' /home/vscode/.zshrc && \
    sudo chsh -s /usr/bin/zsh vscode && \
    # ignore gemset.. we don't need to separate gemsets
    echo "export rvm_ignore_gemsets_flag=1" >> /home/vscode/.rvmrc && \
    echo 'gem: --no-rdoc --no-ri' | sudo tee -a /etc/gemrc > /dev/null && \
    # fix: files may not be writable, so sudo is needed:
    /usr/local/rvm/scripts/rvm fix-permissions system

