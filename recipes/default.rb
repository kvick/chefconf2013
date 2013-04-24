#
# Cookbook Name:: myface
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

user "myface"

# enable keep cache
# default['yum']['keepcache'] = 0

include_recipe "mysql::server"

include_recipe "mysql::server"

# include the mysql Ruby library for chef
include_recipe "mysql::ruby"

# Create mysql connection binding
mysql_connection_info = {:host => 'localhost',
                                        :username => 'root',
                                        :password => node['mysql']['server_root_password']}


# Metadata dep on the database cookbook provides
# access to the mysql_database_providers.

mysql_database 'myface' do
    connection mysql_connection_info
    action :create
end

# Write schema seed file to filesystem

cookbook_file "/tmp/myface-init.sql" do
    source "myface-init.sql"
    owner "root"
    group "root"
    mode "0644"
end

# Seed the database with test data
execute "initialize myface database" do
  command "mysql -h localhost -u root -p#{node['mysql']['server_root_password']} -D myface < /tmp/myface-init.sql"
  not_if "mysql -h localhost -u root -p#{node['mysql']['server_root_password']} -D myface -e 'describe users;'"
end

###################
# Webserver Section
# #################
 
node.default['apache']['default_site_enabled'] = false

include_recipe "apache2"
include_recipe "apache2::mod_php5"
