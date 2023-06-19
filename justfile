#!/usr/bin/env just --justfile

ver := "0.0.1"
pkg_name := "arcy-scripts_" + ver
build_dir := justfile_directory() / "build"
temp_dir := build_dir / "temp"


alias b := build
alias sums := update-checksums
# alias h := show-help
# alias t := test
# alias l := lint

default: 
  @just --list

build:
  @if [[ ! -d {{build_dir}} ]]; then mkdir -p {{build_dir}}; fi
  @if [[ -d {{temp_dir}} ]]; then rm -rf {{temp_dir}}; fi
  
  mkdir -p {{temp_dir}}
  cp src/*.sh justfile README.md LICENSE {{temp_dir}}

  tar czf {{build_dir}}/{{pkg_name}}.tar.gz --directory={{temp_dir}} .
  rm -rf {{temp_dir}}

update-checksums: build
  new_md5sum_value=$(md5sum {{build_dir}}/{{pkg_name}}.tar.gz | cut -d ' ' -f1)
  sed -i '/^md5sums=/c\md5sums=(\"'$new_md5sum_value'\")' PKGBUILD

