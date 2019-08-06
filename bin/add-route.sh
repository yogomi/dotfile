#!/bin/sh

sudo route delete -net 210.254.122.5/32 10.41.1.1
sudo route add -net 210.254.122.5/32 10.41.1.1
