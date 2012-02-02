#!/bin/bash

# This script installs ruby, rubygems, and chef
# this script is added to new EC2 instances started by CloudHelper
# when a new server is started (hash key is :user_data)

set -e -x

#Config
export DEBIAN_FRONTEND=noninteractive
export CHEF_COOKBOOK_PATH=/tmp/cheftime/cookbooks
export CHEF_FILE_CACHE_PATH=/tmp/cheftime


mkdir -p $CHEF_FILE_CACHE_PATH
mkdir -p $CHEF_COOKBOOK_PATH

#chef solo ruby file
echo "file_cache_path \"$CHEF_FILE_CACHE_PATH\"
cookbook_path \"$CHEF_COOKBOOK_PATH\"
role_path []
log_level :debug" > $CHEF_FILE_CACHE_PATH/solo.rb

apt-get update
apt-get --no-install-recommends -y install build-essential ruby ruby-dev rubygems libopenssl-ruby
gem install --no-rdoc --no-ri chef --version=0.9.12
echo 'PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/var/lib/gems/1.8/bin"' > /etc/environment
