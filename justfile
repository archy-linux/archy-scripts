#!/usr/bin/env just --justfile

_ver := "0.0.1"
pkg_name := "arcy-scripts"
build_dir := justfile_directory() / "build"
temp_dir := build_dir / "temp"


alias b := build
alias sums := update-checksums
alias ver := update-pkgver
alias r := release

default: 
  @just --list

build ver=_ver:
  @if [[ ! -d {{build_dir}} ]]; then mkdir -p {{build_dir}}; fi
  @if [[ -d {{temp_dir}} ]]; then rm -rf {{temp_dir}}; fi
  
  mkdir -p {{temp_dir}}
  cp src/*.sh justfile README.md LICENSE {{temp_dir}}

  tar czf {{build_dir}}/{{pkg_name}}_{{ver}}.tar.gz --directory={{temp_dir}} .
  rm -rf {{temp_dir}}

update-checksums ver=_ver: (build ver)
  #!/usr/bin/env sh
  set -euxo pipefail
  new_md5sum_value=$(md5sum {{build_dir}}/{{pkg_name}}_{{ver}}.tar.gz | cut -d ' ' -f1)
  sed -i '/^md5sums=/c\md5sums=(\"'$new_md5sum_value'\")' PKGBUILD

update-pkgver ver=_ver:
  sed -i '/^pkgver=/c\pkgver={{ver}}' PKGBUILD
  sed -i '/^_ver :=/c\_ver := "{{ver}}"' {{justfile()}}

_commit ver=_ver:
  git commit -am "[deploy] Bump version to {{ver}}"
  git push

release ver=_ver: (update-pkgver ver) (update-checksums ver) (build ver) (_commit ver)
  gh release create --generate-notes {{ver}}
  gh release upload {{build_dir}}/{{pkg_name}}_{{ver}}.tar.gz
  @echo "Done."
