#
# Cookbook:: motd
# Recipe:: default
#
# Copyright:: 2022, Kaine Bent, All Rights Reserved.

cookbook_file "/etc/motd" do
  source "motd"
  mode "0644"
end
