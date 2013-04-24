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
node.default['yum']['keepcache'] = 1
include_recipe "yum"
#yum_repository "zenoss" do 
#    repo_name "zenoss" 
#    description "Zenoss Stable repo" 
#    url "http://dev.zenoss.com/yum/stable/" 
#    key "RPM-GPG-KEY-zenoss" 
#    action :add 
#end


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

template "#{node['apache']['dir']}/sites-available/myface.conf" do
    source "apache2.conf.erb"
    notifies :restart, 'service[apache2]'
end

apache_site "myface.conf" do
    enabled true
    notifies :restart, 'service[apache2]'
end

package "php-mysql" do
    action :install
    notifies :restart, "service[apache2]"
end

directory "/srv/apache/myface" do
    action :create
    mode "0755"
    recursive true
end

template "/srv/apache/myface/index.php" do
    source "index.php.erb"
    mode "0644"
end
