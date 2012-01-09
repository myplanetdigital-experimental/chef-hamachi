#
# Cookbook Name:: hamachi
# Recipe:: default
#
# Copyright 2011, Myplanet Digital
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

installer_filename = "logmein-hamachi_#{node[:hamachi][:version]}-"

case node[:kernel][:machine]
# 32-bit architecture
when "i386", "i486", "i686"
  case node[:platform]
  when "debian", "ubuntu"
    installer_filename << "1_i386.deb"
  when "centos", "redhat", "fedora", "suse"
    installer_filename << "1.i486.rpm"
  end
# 64-bit architecture
when "x86_64", "amd64"
  case node[:platform]
  when "debian", "ubuntu"
    installer_filename << "1_amd64.deb"
  when "centos", "redhat", "fedora", "suse"
    installer_filename << "1.x86_64.rpm"
  end
end

remote_file "#{Chef::Config[:file_cache_path]}/#{installer_filename}" do
  source "https://secure.logmein.com/labs/#{installer_filename}"
  action :create_if_missing
end

require_recipe "apt"

package "lsb-core"

dpkg_package "hamachi" do
  source "#{Chef::Config[:file_cache_path]}/#{installer_filename}"
end

service "hamachi" do
  service_name "logmein-hamachi"
  reload_command "/etc/init.d/logmein-hamachi force-reload"
  supports [ :restart, :reload ]
  action [ :enable, :start ]
end

bash "hamachi login" do
  user "root"
  code "hamachi login & wait $!"
  only_if { %x[ sudo hamachi | grep "^[ ]*status" | awk '{ print $3 }' ].strip.match /^offline$/ }
end

bash "hamachi set-nick" do
  user "root"
  code "hamachi set-nick #{node['hamachi']['nickname']} & wait $!"
end

bash "hamachi attach" do
  user "root"
  code "hamachi attach #{node['hamachi']['logmein_account']} & wait $!"
  # Only attach if no account attached (dash)
  only_if { %x[ sudo hamachi | grep '^[ ]*lmi account' | awk '{print $3}' ].strip.match /^-$/ }
end

# If "pending" appears, write to chef log
log "Awaiting account attachment approval: #{node['hamachi']['logmein_account']}" do
  level :warn
  only_if { %x[ sudo hamachi | grep '^[ ]*lmi account' | awk '{print $3 " " $4}'].strip.match /\(pending\)$/ }
end

networks = node['hamachi']['networks']

networks.each do |name, data|
  bash "hamachi joining network: #{name}" do
    user "root"
    code "sleep 1 && hamachi join #{data['id']} '#{data['password']}' & wait $!"
  end
end
