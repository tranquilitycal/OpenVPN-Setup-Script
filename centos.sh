if [[ "$USER" != 'root' ]]; then
echo "This script must be run as root."
exit
fi

yum install wget #Just incase the target system does not have wget.
wget http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
rpm -Uvh epel-release-6-8.noarch.rpm
yum update
yum install openvpn curl -y
cd /etc/openvpn/
wget http://pastebin.com/raw.php?i=bHW1uj8i
mv raw.php?i=bHW1uj8i server.conf
wget https://github.com/OpenVPN/easy-rsa/releases/download/2.2.2/EasyRSA-2.2.2.tgz
tar -xf EasyRSA-2.2.2.tgz
mv EasyRSA-2.2.2 easy-rsa
cd easy-rsa
source ./vars
./clean-all
./build-ca
./build-key-server server
./build-dh
cd keys
cp dh2048.pem ca.crt server.crt server.key /etc/openvpn
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
echo 1 > /proc/sys/net/ipv4/ip_forward
service openvpn start
echo "Installation Complete, your server should be all set up and ready to accept clients."
echo ""
echo "To generate your client keys use the client creation script"