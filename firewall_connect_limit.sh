#!Bash Script
	#Firewall configuration
		#Reconfigure iptables to seperate out attempts to connect too many times on ssh

iptables -F	#Flush all rules from all chains
iptables -X	#delete any user added chains
iptables -P INPUT DROP	#Drop all packets not explicitly accepted

#accept packets that are part of communications already
iptables -A INPUT -s 0/0 -m state --state RELATED,ESTABLISHED -j ACCEPT

iptables -N ssh_traffic_init
iptables -A INPUT -s 0/0 -p tcp --dport 22 --syn -j ssh_traffic_init
iptables -A ssh_traffic_init -m recent --name ssh_input_trap --rcheck --seconds 60 --hitcount 3 --rttl -j DROP
iptables -A ssh_traffic_init -m recent --name ssh_input_trap --set -j RETURN

iptables -N ssh_traffic_throttle
iptables -A INPUT -s 0/0 -p tcp --dport 22 --syn -j ssh_traffic_throttle
iptables -A ssh_traffic_throttle -m connlimit --connlimit-above 3 -j DROP
iptables -A ssh_traffic_throttle -m limit --limit 3/m --limit-burst 1 -j ACCEPT
