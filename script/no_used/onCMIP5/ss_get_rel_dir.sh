#!/bin/bash

abs_dir=$1

root_dir=$2

echo "${abs_dir#$root_dir/}"
