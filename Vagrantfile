Vagrant.configure("2") do |config|
    config.vm.box = "centos/stream8"
    config.vm.define 'centos'
    config.vm.provision "ansible" do |ansible|
        ansible.playbook = "playbook.yml"
    end
end