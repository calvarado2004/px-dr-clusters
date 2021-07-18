REL="/2.7.3"  # Portworx v2.7 release

latest_stable=$(curl -fsSL "https://install.portworx.com$REL/?type=dock&stork=false&aut=false" | awk '/image: / {print $2}')

# Download OCI bits (reminder, you will still need to run `px-runc install ..` after this step)
sudo docker run -d --entrypoint /runc-entry-point.sh \
    --rm -i --privileged=true \
    -v /opt/pwx:/opt/pwx -v /etc/pwx:/etc/pwx \
    --upgrade \
    $latest_stable

sleep 20s

sudo /opt/pwx/bin/px-runc install -c virtualbox-cluster -k etcd://192.168.73.10:2379,etcd://192.168.73.11:2379,etcd://192.168.73.12:2379 -cluster_domain witness -a -d eth1 -m eth1 -x swarm

sudo systemctl enable portworx.service

sudo systemctl start portworx.service
