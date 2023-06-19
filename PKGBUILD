# Maintainer: Anas Elgarhy <anas.elgarhy.dev@gmail.com>
pkgname=archy-scripts
pkgver=0.0.1
pkgrel=1
epoch=
pkgdesc="The archy linux utilty scripts"
arch=('any')
url="https://github.com/archy-linux/$pkgname"
license=('Unlicense')
groups=('archy-linux' 'archy')
depends=('xorg-xinput' 'bash')
makedepends=()
checkdepends=()
optdepends=()
provides=('touchpad-toggle' 'usbmount')
conflicts=()
changelog=
source=("$url/archive/refs/tags/$pkgver.tar.gz")
md5sums=()
validpgpkeys=('4514 F39E 840E 0FFC DE9D  2815 0501 802A 1D49 6528')

package() {
	cd "$pkgver" || exit 1
  # shellcheck disable=SC2154
  install -Dm755 touchpad_toggle.sh "$pkgdir/usr/bin/${provides[0]}"
  install -Dm755 usbmount.sh "$pkgdir/usr/bin/${provides[1]}"

  install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
  install -Dm644 REAME.md "$pkgdir/usr/share/doc/$pkgname/README.md"
}
