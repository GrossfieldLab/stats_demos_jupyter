#!/bin/bash -x

cd base-notebook
docker build  --rm --force-rm -t t32/base-notebook:latest .
