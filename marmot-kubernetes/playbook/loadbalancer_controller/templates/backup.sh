#!/bin/bash
systemctl stop haproxy
systemctl stop coredns
systemctl stop loadbalancer_controller

