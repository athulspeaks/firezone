#!/bin/bash
set -ex

# Install prerequisites
sudo yum groupinstall -y 'Development Tools'
sudo yum install -y \
  gcc-c++ \
  zsh \
  tree \
  rsync \
  autoconf \
  automake \
  procps \
  openssl-devel \
  ncurses-devel \
  curl \
  git \
  findutils \
  unzip \
  glibc-all-langpacks \
  rpmdevtools \
  rpmlint \
  openssl \
  net-tools \
  systemd \
  postgresql-server \
  iptables \
  wireguard-tools

# Set locale
sudo bash -c 'echo "LANG=en_US.UTF-8" > /etc/locale.conf'
sudo localectl set-locale LANG=en_US.UTF-8


# Set up Postgres
sudo postgresql-setup --initdb --unit postgresql
# Fix postgres login
# sudo cat <<EOT > /var/lib/pgsql/data/pg_hba.conf
# local   all             all                                     peer
# host    all             all             127.0.0.1/32            md5
# host    all             all             ::1/128                 md5
# EOT
sudo systemctl enable postgresql
sudo systemctl restart postgresql

# Install asdf
git clone --depth 1 https://github.com/asdf-vm/asdf.git $HOME/.asdf
echo '. $HOME/.asdf/asdf.sh' >> $HOME/.bashrc
echo '. $HOME/.asdf/completions/asdf.bash' >> $HOME/.bashrc
. $HOME/.asdf/asdf.sh
asdf plugin-add nodejs
asdf plugin-add erlang
asdf plugin-add elixir
cd /vagrant
asdf install

# Build release
export MIX_ENV=prod
mix local.hex --force
mix local.rebar --force
mix deps.get --only prod
mix deps.compile
npm ci --prefix apps/fz_http/assets --progress=false --no-audit --loglevel=error
npm run --prefix ./apps/fz_http/assets deploy
cd apps/fz_http && mix phx.digest && cd /vagrant
mix release
tar -zcf $PKG_FILE -C _build/prod/rel/ firezone

# file=(/tmp/firezone*.tar.gz)
# /tmp/install.sh /tmp/$file
# systemctl start firezone.service
# systemctl status firezone.service
# journalctl -xeu firezone