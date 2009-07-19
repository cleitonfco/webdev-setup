#!/bin/bash

if [ "$(whoami)" != 'root' ]; then
  echo "You have no permission to run $0 as non-root user."
  exit 1
fi

title='WebDev Setup - Configurations'
output=`tempfile`

# Install Functions
# ---------------------------------------------------------------------------
install_ruby() {
  echo "* Instaling Ruby 1.8..."
  apt-get -y install ruby1.8 ruby1.8-dev irb1.8 ri1.8 rdoc1.8 libopenssl-ruby build-essential libxml-ruby1.8 libxml2-dev libxslt1-dev libreadline-ruby1.8
  ln -s /usr/bin/ruby1.8 /usr/bin/ruby
  ln -s /usr/bin/rdoc1.8 /usr/bin/rdoc
  ln -s /usr/bin/ri1.8 /usr/bin/ri
  ln -s /usr/bin/irb1.8 /usr/bin/irb
  return
}

install_rubygems() {
  echo "* Instaling RubyGems..."
  wget -nv http://rubyforge.org/frs/download.php/57643/rubygems-1.3.4.tgz
  tar -xzf rubygems-1.3.4.tgz
  cd rubygems-1.3.4
  ruby setup.rb install
  ln -s /usr/bin/gem1.8 /usr/bin/gem
  cd ..
  rm -rf rubygems-1.3.4
  return
}

install_rails() {
  echo "* Instaling Rails..."
  gem sources -a http://gems.github.com
  gem update --system
  gem install rails
  return
}

install_gem() {
  if [ $1 != '0' ]; then
    gem install $2 --no-ri --no-rdoc
  fi
  return
}

install_gems() {
  gems='wirble daemons rack rake rcov json hpricot treetop hirb mislav-will_paginate nokogiri passenger'
  echo '* Instaling Gems...'
  gem install $gems --no-ri --no-rdoc
  install_gem $authlogic 'authlogic'
  install_gem $brstring 'brstring'
  install_gem $capistrano 'capistrano'
  install_gem $capistranoext 'capistrano-ext'
  install_gem $cucumber 'cucumber'
  install_gem $faker 'faker'
  install_gem $github 'github'
  install_gem $jsonpure 'json_pure'
  install_gem $machinist 'notahat-machinist'
  install_gem $oauth 'oauth'
  install_gem $redgreen 'redgreen'
  install_gem $remarkable_rails 'remarkable_rails'
  install_gem $rspec 'rspec'
  install_gem $rspecrails 'rspec-rails'
  install_gem $syntax 'syntax'
  install_gem $thin 'thin'
  install_gem $paperclip 'thoughtbot-paperclip'
  install_gem $shoulda 'thoughtbot-shoulda'
  install_gem $twitter 'twitter'
  install_gem $vlad 'vlad'
  install_gem $webrat 'webrat'
  install_gem $xmpp4r 'xmpp4r'
  install_gem $zentest 'ZenTest'

  if [ $rmagick != '0' ]; then
    apt-get install -y imagemagick libmagickwand-dev
    gem install rmagick --no-ri --no-rdoc
  fi

  if [ $paranoid != '0' ]; then
    gem install jchupp-is_paranoid -v 0.8.2 --no-ri --no-rdoc
  fi
  return
}

install_sqlite() {
  if [ $database = 'on' -a $sq != '0' ]; then
    echo '* Instaling Sqlite...'
    apt-get -y install sqlite3 libsqlite3-ruby libsqlite3-dev libdbd-sqlite3-ruby libsqlite3-ruby
    gem install sqlite3-ruby
  fi
  return
}

install_mysql() {
  if [ $database = 'on' -a $my != '0' ]; then
    echo '* Instaling MySql...'
    apt-get -y install mysql-client-5.0 mysql-server-5.0 mysql-admin python-mysqldb libmysql-ruby libmysqlclient15-dev mysql-query-browser
    gem install mysql
  fi
  return
}

install_postgres() {
  if [ $database = 'on' -a $pg != '0' ]; then
    echo '* Instaling Postgres...'
    apt-get -y install libpq-dev libpgsql-ruby pgadmin3 postgresql-8.3 postgresql-client-8.3 postgresql-client-common postgresql-common postgresql-contrib-8.3
    gem install postgres
  fi
  return
}

install_git() {
  echo '* Instaling Git...'
  apt-get -y install git-core git-doc git-gui gitk
  return
}

install_apache() {
  if [ $apache = 'on' ]; then
    echo '* Instaling Apache...'
    apt-get -y install apache2 apache2-mpm-prefork apache2-prefork-dev
  fi
  return
}

install_passenger_apache() {
  if [[ $apache = 'on' && $passenger_apache = '1' ]]; then
    echo '* Instaling Passenger to Apache Server...'
    passenger-install-apache2-module
  fi
  return
}

install_nginx() {
  if [[ $nginx = 'on' && $passenger_nginx != '1' ]]; then
    echo '* Instaling NGinx Server...'
    apt-get -y install nginx
  fi
  return
}

install_passenger_nginx() {
  if [[ $nginx = 'on' && $passenger_nginx = '1' ]]; then
    echo '* Instaling Nginx Server with Passenger support...'
    passenger-install-nginx-module
  fi
  return
}

install_php() {
  echo '* Instaling PHP5...'
  apt-get -y install php5 libapache2-mod-php5 php5-mysql phpmyadmin libapache2-mod-auth-mysql
  return
}

# ---------------------------------------------------------------------------
# Configurations
# ---------------------------------------------------------------------------

# Firstly, install dialog
# ---------------------------------------------------------------------------
apt-get -y install dialog

# Ask for Databases
# ---------------------------------------------------------------------------
dialog --backtitle "$title" --title "Databases" --separate-output \
       --checklist "\nSelect below the databases you want to install. Your choices will also be enabled to your rails applications.\n" 12 50 3 \
       1 "MySql" off \
       2 "Postgres" off \
       3 "Sqlite" off \
       2> $output

input=$?
clear

if [ $input != 1 -a $input != 255 ]; then
  database='on'
  options=`cat $output`
  my=`expr index "$options" 1`
  pg=`expr index "$options" 2`
  sq=`expr index "$options" 3`
else
  database='off'
fi

# Config Apache Server
# ---------------------------------------------------------------------------
dialog --backtitle "$title" --title "Apache Server" --separate-output \
       --checklist "\nYou want to install the Apache Server?\n" 10 50 1 \
       1 "With support for Passenger" on \
       2> $output
input=$?
clear

if [ $input != 1 -a $input != 255 ]; then
  apache='on'
  passenger_apache=`cat $output`
else
  apache='off'
fi

# Config Nginx Server
# ---------------------------------------------------------------------------
dialog --backtitle "$title" --title "NGinx Server" --separate-output \
       --checklist "\nYou want to install the NGinx Server?\n" 10 50 1 \
       1 "With support for Passenger" on \
       2> $output
input=$?
clear

if [ $input != 1 -a $input != 255 ]; then
  nginx='on'
  passenger_nginx=`cat $output`
else
  nginx='off'
fi

# Ask for Gems
# ---------------------------------------------------------------------------
dialog --backtitle "$title" --title "Gems" --separate-output \
       --checklist "\nSelect the gems you want to install (1/3):\n" 25 120 10 \
       0 "authlogic : A clean, simple, and unobtrusive ruby authentication solution." on \
       1 "brstring : brstring é uma das gems que compoem o Brazilian Rails" on \
       2 "capistrano : Simple. The way it should be." on \
       3 "capistrano-ext : Useful task libraries and methods for Capistrano" on \
       4 "cucumber : Executable Feature scenarios" on \
       5 "faker : A port of Perl's Data::Faker - Generates fake names, phone numbers, etc." on \
       6 "github : The official 'github' command line helper for simplifying your GitHub experience." on \
       7 "jchupp-is_paranoid : allowing you to hide and restore records without actually deleting them." on \
       8 "json_pure : A JSON implementation in Ruby" on \
       9 "notahat-machinist : Fixtures aren't fun. Machinist is." on \
       2> $output

input=$?
clear

if [ $input != 1 -a $input != 255 ]; then
  options=`cat $output`
  authlogic=`expr index "$options" 0`
  brstring=`expr index "$options" 1`
  capistrano=`expr index "$options" 2`
  capistranoext=`expr index "$options" 3`
  cucumber=`expr index "$options" 4`
  faker=`expr index "$options" 5`
  github=`expr index "$options" 6`
  paranoid=`expr index "$options" 7`
  jsonpure=`expr index "$options" 8`
  machinist=`expr index "$options" 9`
fi

dialog --backtitle "$title" --title "Gems" --separate-output \
       --checklist "\nSelect the gems you want to install (2/3):\n" 25 120 10 \
       0 "oauth : OAuth Core Ruby implementation" on \
       1 "redgreen : redgreen is an expanded version of Pat Eyler's RedGreen" on \
       2 "remarkable_rails : collection of matchers and macros with I18n for Rails" on \
       3 "rmagick : Ruby binding to ImageMagick" on \
       4 "rspec : rspec" on \
       5 "rspec-rails : rspec for rails" on \
       6 "syntax : Syntax is Ruby library for performing simple syntax highlighting." on \
       7 "thin : A thin and fast web server" on \
       8 "thoughtbot-paperclip : File attachments as attributes for ActiveRecord" on \
       9 "thoughtbot-shoulda : Making tests easy on the fingers and eyes" on \
       2> $output

input=$?
clear

if [ $input != 1 -a $input != 255 ]; then
  options=`cat $output`
  oauth=`expr index "$options" 0`
  redgreen=`expr index "$options" 1`
  remarkable_rails=`expr index "$options" 2`
  rmagick=`expr index "$options" 3`
  rspec=`expr index "$options" 4`
  rspecrails=`expr index "$options" 5`
  syntax=`expr index "$options" 6`
  thin=`expr index "$options" 7`
  paperclip=`expr index "$options" 8`
  shoulda=`expr index "$options" 9`
fi

dialog --backtitle "$title" --title "Gems" --separate-output \
       --checklist "\nSelect the gems you want to install (3/3):\n" 15 120 5 \
       0 "twitter : wrapper for the twitter api (oauth only)" on \
       1 "vlad : Vlad the Deployer is pragmatic application deployment automation, without mercy" on \
       2 "webrat : Webrat. Ruby Acceptance Testing for Web applications" on \
       3 "xmpp4r : XMPP4R is an XMPP/Jabber library for Ruby." on \
       4 "ZenTest : ZenTest provides 4 different tools: zentest, unit_diff, autotest, and multiruby" on \
       2> $output

input=$?
clear

if [ $input != 1 -a $input != 255 ]; then
  options=`cat $output`
  twitter=`expr index "$options" 0`
  vlad=`expr index "$options" 1`
  webrat=`expr index "$options" 2`
  xmpp4r=`expr index "$options" 3`
  zentest=`expr index "$options" 4`
fi

# Start Setup
# ---------------------------------------------------------------------------
apt-get update -qq
apt-get upgrade -qq
install_ruby
install_rubygems
install_rails
install_git
install_gems
install_mysql
install_postgres
install_sqlite
install_apache
install_passenger_apache
install_nginx
install_passenger_nginx
install_php

#java = <<JAVA
#echo '>> Instaling Java' &&
#apt-get install -y sun-java6-jre &&
#echo '>> Instaling Plugin Java para Browsers' &&
#apt-get install -y sun-java6-plugin
#JAVA
