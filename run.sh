#!/usr/bin/env bash
root_dir=$(dirname $0)
src_dir=${root_dir}/src
build_dir=${root_dir}/build
bin_dir=${root_dir}/bin

input_filename=$1
args=`cat ${input_filename}`

# TODO launch your program from here
# example: python my_script.py ${args}
# example: ruby my_script.rb ${args}
cat ${input_filename} # TODO remove this line

