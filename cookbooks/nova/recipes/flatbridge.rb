#
# Cookbook Name:: nova
# Recipe:: flatbridge
#
# Copyright 2011, Anso Labs
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
include_recipe "apt"

%w{bridge-utils}.each do |pkg|
  package pkg
end

file "/root/flatbridge.sh" do
  content <<-EOH
ETH=`ip addr | grep #{node[:nova][:my_ip]} | cut -d' ' -f11`
if [ "$ETH" == "#{node[:nova][:bridge]}" ]; then
  exit
fi
brctl addbr #{node[:nova][:bridge]}
brctl addif #{node[:nova][:bridge]} $ETH
ifconfig #{node[:nova][:bridge]} up
ip addr del #{node[:nova][:my_ip]}/32 scope global dev $ETH
ip addr add #{node[:nova][:my_ip]}/32 scope global dev br100
EOH
  owner "root"
  group "root"
end

execute "bash /root/flatbridge.sh" do
  user "root"
end
