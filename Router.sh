#!/bin/bash
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.57.0.0/16