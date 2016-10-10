#! /bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#echo>ZeroNet;vi ZeroNet;chmod 777 ZeroNet;[ ! -e '/usr/bin/setsid' ] && nohup ./ZeroNet || setsid ./ZeroNet

function doNet(){
	sysctl=/etc/sysctl.conf
    limits=/etc/security/limits.conf
	sed -i '/* soft nofile/d' $limits; echo '* soft nofile 512000' >> $limits
	sed -i '/* hard nofile/d' $limits; echo '* hard nofile 1024000' >> $limits
    ulimit -n 512000
	sed -i '/fs.file-max/d' $sysctl; echo 'fs.file-max = 1024000' >> $sysctl
	sed -i '/nofile/d' $sysctl; echo 'net.core.rmem_max = 67108864' >> $sysctl
	sed -i '/net.core.rmem_max/d' $sysctl; echo 'net.core.wmem_max = 67108864' >> $sysctl
	sed -i '/net.core.netdev_max_backlog/d' $sysctl; echo 'net.core.netdev_max_backlog = 250000' >> $sysctl
	sed -i '/net.core.somaxconn/d' $sysctl; echo 'net.core.somaxconn = 4096' >> $sysctl
	sed -i '/net.ipv4.tcp_syncookies/d' $sysctl; echo 'net.ipv4.tcp_syncookies = 1' >> $sysctl
	sed -i '/net.ipv4.tcp_tw_reuse/d' $sysctl; echo 'net.ipv4.tcp_tw_reuse = 1' >> $sysctl
	sed -i '/net.ipv4.tcp_tw_recycle/d' $sysctl; echo 'net.ipv4.tcp_tw_recycle = 0' >> $sysctl
	sed -i '/net.ipv4.tcp_fin_timeout/d' $sysctl; echo 'net.ipv4.tcp_fin_timeout = 30' >> $sysctl
	sed -i '/net.ipv4.tcp_keepalive_time/d' $sysctl; echo 'net.ipv4.tcp_keepalive_time = 1200' >> $sysctl
	sed -i '/net.ipv4.ip_local_port_range/d' $sysctl; echo 'net.ipv4.ip_local_port_range = 10000 65000' >> $sysctl
	sed -i '/net.ipv4.tcp_max_syn_backlog/d' $sysctl; echo 'net.ipv4.tcp_max_syn_backlog = 8192' >> $sysctl
	sed -i '/net.ipv4.tcp_max_tw_buckets/d' $sysctl; echo 'net.ipv4.tcp_max_tw_buckets = 5000' >> $sysctl
	sed -i '/net.ipv4.tcp_fastopen/d' $sysctl; echo 'net.ipv4.tcp_fastopen = 3' >> $sysctl
	sed -i '/net.ipv4.tcp_mem/d' $sysctl; echo 'net.ipv4.tcp_mem = 25600 51200 102400' >> $sysctl
	sed -i '/net.ipv4.tcp_rmem/d' $sysctl; echo 'net.ipv4.tcp_rmem = 4096 87380 67108864' >> $sysctl
	sed -i '/net.ipv4.tcp_wmem/d' $sysctl; echo 'net.ipv4.tcp_wmem = 4096 65536 67108864' >> $sysctl
	sed -i '/net.ipv4.tcp_mtu_probing/d' $sysctl; echo 'net.ipv4.tcp_mtu_probing = 1' >> $sysctl
	sed -i '/net.ipv4.tcp_congestion_control/d' $sysctl; echo 'net.ipv4.tcp_congestion_control = hybla' >> $sysctl
    sysctl -p
    clear
}

doNet
yum clean all;yum clean metadata;yum clean dbcache;yum -y update
yum -y install msgpack-python python-gevent git python-dev tor

wget -c --no-check-certificate https://github.com/HelloZeroNet/ZeroBundle/releases/download/0.1.1/ZeroBundle-linux64-v0.1.1.tar.gz -O ZeroBundle-linux64-v0.1.1.tar.gz
tar zxf ZeroBundle-linux64-v0.1.1.tar.gz
rm -f ZeroBundle-linux64-v0.1.1.tar.gz
cd ZeroBundle
if [ ! -d "ZeroNet" ]; then
    git clone https://github.com/HelloZeroNet/ZeroNet.git
fi
rm -f $0
bash ZeroNet.sh --ui_ip "*"
