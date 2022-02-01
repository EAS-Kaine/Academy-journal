ruby_block insert_line do
  block do
    file = Chef::Util::FileEdit.new(/etc/sysconfig/network-scripts/ifcfg-ens160)
    file.insert_line_if_no_match(GATEWAY=192.168.1.248, GATEWAY=192.168.1.254)
    file.write_file
  end
end
