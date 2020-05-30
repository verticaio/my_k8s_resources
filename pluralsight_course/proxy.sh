###  Configure Proxy for system
sudo echo -e 'HTTP_PROXY=http://10.0.9.24:8080/ \nHTTPS_PROXY=http://10.0.9.24:8080/ \nhttp_proxy=http://10.0.9.24:8080/ \nhttps_proxy=http://10.0.9.24:8080/ \nftp_proxy=ftp://10.0.9.24:8080/ \nALL_PROXY=socks://10.0.9.24:8080/ \nall_proxy=socks://10.0.9.24:8080 \nexport HTTP_PROXY HTTPS_PROXY https_proxy http_proxy ftp_proxy  ALL_PROXY all_proxy \nexport no_proxy="127.0.0.1, localhost, 172* "' >>  /etc/profile
sudo echo "proxy=http://10.0.9.24:8080/" >>  /etc/yum.conf
sudo mkdir /etc/systemd/system/docker.service.d
sudo touch /etc/systemd/system/docker.service.d/http-proxy.conf
sudo echo -e "[Service] \n
Environment=\"HTTP_PROXY=10.0.9.24:8080/\" \n
Environment=\"HTTPS_PROXY=10.0.9.24:8080/\"" > /etc/systemd/system/docker.service.d/http-proxy.conf
sudo systemctl daemon-reload 
sudo systemctl restart docker
sudo systemctl status docker
