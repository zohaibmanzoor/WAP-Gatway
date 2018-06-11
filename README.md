# WAP Gatway

WAP Gateway is used in Telecom networks to perform content adaptation for legacy handsets. Older handsets support WAP protocol family (WAP1.x and WAP2.0) but webservers only understand HTML so WAP gateway performs this translation function. In addition to protocol conversion, WAP gateway is also used to perform content compression and caching as legacy handsets typically only support 2G thereby improving user experience. Since it’s a legacy node so typically does not warrant much cost from Telcos operator point of view. 
In this article I will show the way to implement WAP gateway functionality using totally open source tools. I did this as a project recently for a Telco operator which resulted in significant savings for the company and we were able to handle around 2 Gbps traffic without any hickups.
Opensource Tools to be used
1.	Squid (HTTP Proxy and Caching)
2.	Ziproxy (Content Compression and Resizing)
3.	Kannel (WAP 1.x gateway)
4.	Zabbix (NMS)

Using Virtualization:
Running the WAP gateway on virtualization is a great way to scale WAP gateway if you have multiple GGSNs in your network and proxy traffic is large. Compute resources can also be effectively utilized using virtualization. Usually most GGSN performs the functionality called port redirection which is redirecting the ingress traffic coming on certain IP+port combination to a different IP and port. You can use port redirection to distribute traffic to WAP gateway VMs or alternatively use a hardware load balancer

Installation Steps:
Follow below steps for installation.

1.	Install squid (Depending upon your Distro)
apt-get install squid
Or
sudo yum install squid

2.	Install Ziproxy
apt-get install ziproxy
Or
Download source from below link
http://ziproxy.sourceforge.net
Install dependencies zlib, libgif, libpng, libjpeg, gifunlib, libjasper and libsasl. Use yum search <package name> to get the exact rpm package name if you get yum error
Unzip the package and compile the source.

./configure
make
make install

3.	Follow below link to install Zabbix. You might need a separate VM for NMS. To monitor client machines, zabbix-client is installed on the clients (yum install or apt-get install zabbix-agent 
https://www.tecmint.com/install-and-configure-zabbix-monitoring-on-debian-centos-rhel/

4.	Follow below link to install Kannel
https://www.kannel.org/download/kannel-userguide-snapshot/userguide.html

Setting Up Wap Gateway
1.	Edit /etc/squid.conf to allow traffic on only localhost. Squid will receive traffic from ziproxy on port 3128 on the localhost. Detailed configuration is available on my github account (https://github.com/zohaibmanzoor/vWAP-Gateway)
http_access allow localhost
http_port 3128
2.	 Create and edit ziproxy configuration file (/etc/ziproxy.conf). You can copy the file from my github account. Port 8080 is the redirected port on which GGSN will forward traffic to WAP gateway
NextProxy="localhost"
Port = 8080
3.	Start WAP gateway processes
sudo systemctl start squid
sudo systemctl start ntpd
ziproxy -d -c /etc/ziproxy.conf

4.	Test WAP gateway by configuring port redirection in GGSN