#!/bin/bash
systemctl start haproxy
systemctl start coredns
systemctl start loadbalancer_controller
