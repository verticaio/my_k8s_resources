

sudo mv /etc/systemd/system/docker.service.d/http-proxy.conf /etc/systemd/system/docker.service.d/http-proxy.conf.old
sudo systemctl daemon-reload 
sudo systemctl restart docker
sudo systemctl status docker
