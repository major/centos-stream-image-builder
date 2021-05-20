Vagrant.configure("2") do |config|
    config.vm.box = "centos/stream8"
    config.vm.define 'centos'
    config.disksize.size = '20GB'
    config.vm.provision "shell", path: "provision.sh"
end