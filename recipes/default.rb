#
# Cookbook Name:: logmein-hamachi
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

case node[:logmein][:install_method]
when "binaries"

  default[:logmein][:hamachi][:version] = "2.0.1.13"
  installer_filename = "logmein-hamachi-#{node[:logmein][:hamachi][:version]}-"
  
  case node[:kernel][:machine]
  # 32-bit architecture
  when "i386", "i486"
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
  
  package "logmein-hamachi" do
    source "#{Chef::Config[:file_cache_path]}/#{installer_filename}"
  end

when "source"
  require_recipe "build-essentials"
  case node[:kernal][:machine]
  when "i386", "i486"
    installer_filename = "logmein-hamachi-2.0.1.13-x86.tgz"
  when "x86_64", "amd64"
    installer_filename = "logmein-hamachi-2.0.1.13-x64.tgz"
  end

  remote_file "#{Chef::Config[:file_cache_path]}/#{installer_filename}" do
    source "https://secure.logmein.com/labs/#{installer_filename}"
    mode "0644"
    action :create_if_missing
  end

  bash "build logmein hamachi" do
    cwd Chef::Config[:file_cache_path]
    code <<-EOH
    tar -xvf #{installer_filename}
    (cd #{installer_filename.split(".")[-string.split(".").length..-2].join(".")}\
      && make\
      && make install)
    EOH
  end
end
