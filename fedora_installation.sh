#/usr/bin/env bash
set -euo pipefail

source './decorations.sh'

install() {
  for app in "$@"
  do
    print_process "Installing app: $app"
    sudo dnf install "$app" -y >> /dev/null 2>&1
  done
}

enable_rmp_fusion() {
  sudo dnf install \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
  sudo dnf update -y
}

install_chrome() {
  sudo dnf install fedora-workstation-repositories
  sudo dnf config-manager --set-enabled google-chrome
  install google-chrome-stable 
}

install_main_apps() {
  apps_to_install=(keepassxc telegram-desktop terminator bash-completion vim)
  for app in "${apps_to_install[@]}"
  do
    install $app
  done
}

install_rvm_if_not_installed() {
  rvm >> /dev/null 2>&1
  case $? in
    '0')
      print_info 'RVM is already installed'
      rvm install $RUBY_VERSION
      cd .
      cd .
      print_info 'Current ruby version is:'
      rvm current
      ;;
    *)
      install_rvm
      ;;
  esac
}

install_rvm() {
  command curl -sSL https://rvm.io/mpapis.asc | sudo gpg --import -
  \curl -sSL https://get.rvm.io | bash -s head
  source ~/.bashrc
  print_ok 'Installed RVM'
  rvm install $RUBY_VERSION
  cd $ROOT_PATH
  print_ok 'Successfully installed ruby'
  print_process 'Current ruby version is:'
  rvm current
}

install_postgres(){
  sudo dnf install https://download.postgresql.org/pub/repos/yum/reporpms/F-31-x86_64/pgdg-fedora-repo-latest.noarch.rpm -y
  sudo apt update >> /dev/null 2>&1
  install postgresql11-server postgresql11 libpq-devel
  rpm -qi postgresql11-server
  sudo /usr/pgsql-11/bin/postgresql-11-setup initdb
  sudo systemctl start postgresql-11
  sudo systemctl enable postgresql-11
  sudo -u postgres psql -c "alter user postgres with password 'password'"
}

install_redis() {
  install redis-server
}

install_sublime() {
  sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
  sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
  install sublime-text
}

install_system_deps() {
  install_postgres
  install_redis
  install_rvm
}

install_apps() {
  install_chrome
  install_sublime
}

#enable_rmp_fusion
#install_apps
#install_system_deps
#install_main_apps
install_rvm

