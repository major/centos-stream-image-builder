Vagrant.configure("2") do |config|
    config.vm.box = "centos/stream8"

    config.vm.define 'centos'

    # Prevent SharedFoldersEnableSymlinksCreate errors
    config.vm.synced_folder ".", "/vagrant", disabled: true
end