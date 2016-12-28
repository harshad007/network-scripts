#!Bash script
	#Script to reconfigure IPTABLE rules

iptables -F	#flush all rules from all chains

iptables -P INPUT DROP #Drop all packets (not expicitly accepted)

# Accept packets that are part of communication already (ssh)
iptables -A INPUT -s 0/0 -m state --state RELATED,ESTABLISHED -j ACCEPT

#accept first sent packet "syn" from ssh
iptables -A INPUT -s 0/0 -p tcp --syn --dport 22 -j ACCEPT
