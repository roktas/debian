Vagrant.configure("2") do |config|
  # config.vm.box = "debian/trixie64"
  config.vm.box = "rreye/debian-13"

  config.vm.provider "virtualbox" do |virtualbox|
    virtualbox.cpus = 2
    virtualbox.customize ["modifyvm", :id, "--vram", "64"]
    virtualbox.linked_clone = true
    virtualbox.memory = 4096
  end

  # config.vm.provider "libvirt" do |libvirt|
  #   libvirt.cpus = 2
  #   libvirt.memory = 4096
  # end

  if File.exist?("/usr/share/virtualbox/VBoxGuestAdditions.iso")
    config.vm.disk :dvd, name: "GuestAdditions", file: "/usr/share/virtualbox/VBoxGuestAdditions.iso"
  end

  config.vm.provision "provision", type: "shell", run: "never" do |script|
    script.privileged = true
    script.inline = "bash /vagrant/install.sh"
  end
end
