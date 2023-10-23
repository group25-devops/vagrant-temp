domain = "kubernetes.lab"
control_plane_endpoint = "k8s-master." + domain + ":6443"
pod_network_cidr = "10.244.0.0/16"
pod_network_type = "calico" # choose between calico and flannel
K8S_POD_NETWORK_TYPE = "pod_network_type"
master_node_ip = "192.168.57.100"

Vagrant.configure("2") do |config|
    config.ssh.insert_key = false
    config.vm.provision :shell, path: "kubeadm/bootstrap.sh"
    config.vm.define "master" do |master|
        master.vm.box = "ubuntu/focal64"
        master.vm.hostname = "k8s-master.#{domain}"
        master.vm.network "private_network", ip: "#{master_node_ip}"
        master.vm.provision "shell", env: {"DOMAIN" => domain, "MASTER_NODE_IP" => master_node_ip} ,inline: <<-SHELL 
        echo "$MASTER_NODE_IP k8s-master.$DOMAIN k8s-master" >> /etc/hosts 
        SHELL
        master.vm.provision "shell", path: "kubeadm/init-master.sh", env: {"K8S_CONTROL_PLANE_ENDPOINT" => control_plane_endpoint, "K8S_POD_NETWORK_CIDR" => pod_network_cidr, "K8S_POD_NETWORK_TYPE" => pod_network_type, "MASTER_NODE_IP" => master_node_ip}
    end
    config.vm.provider "virtualbox" do |vb|
        vb.memory = "2048"
        vb.cpus = "2"
        vb.customize ["modifyvm", :id, "--nic1", "nat"]
    end
end
