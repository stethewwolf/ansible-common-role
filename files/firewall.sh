#!/bin/bash


# reject all incoming traffic 
sudo iptables -P INPUT  DROP
sudo iptables -P FORWARD  DROP

# accept all outgoing traffic
sudo iptables -P OUTPUT  ACCEPT

# Allow traffic over loopback (lo) traffic 
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT ! -i lo -d 127.0.0.0/8 -j REJECT

# maintain established connection
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# Allow ssh connections
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# allow ping
# https://security.stackexchange.com/questions/22711
sudo iptables -A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT

# regist on kernel log rejected connection (shown by 'dmesg')
sudo iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables denied: " --log-level 7

# block ipv6 networking
sudo ip6tables -P OUTPUT DROP
sudo ip6tables -P INPUT DROP
sudo ip6tables -P FORWARD DROP

