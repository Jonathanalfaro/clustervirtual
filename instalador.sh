#!/usr/bin/env bash
yum -y update
yum -y groupinstall Base
yum -y groupinstall "Development tools"

