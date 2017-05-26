#!/bin/bash -x
# Build a base-notebook
cd base-notebook
docker build  --rm --force-rm -t t32/base-notebook:latest .
