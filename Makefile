# This software is a part of the A.O.D (https://apprepo.de) project
# Copyright 2020 Alex Woroschilow (alex.woroschilow@gmail.com)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
PWD:=$(shell pwd)

all: clean

	mkdir --parents $(PWD)/build
	mkdir --parents $(PWD)/build/AppDir

	wget --output-document="$(PWD)/build/OnlyOffice.AppImage" "http://download.onlyoffice.com/install/desktop/editors/linux/DesktopEditors-x86_64.AppImage"
	chmod +x $(PWD)/build/OnlyOffice.AppImage

	wget --no-check-certificate --output-document=$(PWD)/build/build.rpm http://mirror.centos.org/centos/8/AppStream/x86_64/os/Packages/gtk3-3.22.30-6.el8.x86_64.rpm
	cd $(PWD)/build && rpm2cpio $(PWD)/build/build.rpm | cpio -idmv && cd ..

	wget --no-check-certificate --output-document=$(PWD)/build/build.rpm http://mirror.centos.org/centos/8/AppStream/x86_64/os/Packages/atk-2.28.1-1.el8.x86_64.rpm
	cd $(PWD)/build && rpm2cpio $(PWD)/build/build.rpm | cpio -idmv && cd ..

	wget --no-check-certificate --output-document=$(PWD)/build/build.rpm http://mirror.centos.org/centos/8/AppStream/x86_64/os/Packages/at-spi2-atk-2.26.2-1.el8.x86_64.rpm
	cd $(PWD)/build && rpm2cpio $(PWD)/build/build.rpm | cpio -idmv && cd ..

	wget --no-check-certificate --output-document=$(PWD)/build/build.rpm http://mirror.centos.org/centos/8/AppStream/x86_64/os/Packages/at-spi2-core-2.28.0-1.el8.x86_64.rpm
	cd $(PWD)/build && rpm2cpio $(PWD)/build/build.rpm | cpio -idmv && cd ..
		
	cd $(PWD)/build && $(PWD)/build/OnlyOffice.AppImage --appimage-extract

	rm -f $(PWD)/build/squashfs-root/asc-de.png
	rm -f $(PWD)/build/squashfs-root/usr/share/metainfo/desktopeditors.appdata.xml

	cp --force $(PWD)/AppDir/onlyoffice.svg $(PWD)/build/squashfs-root/asc-de.svg
	cp --force --recursive $(PWD)/build/usr/lib64/* $(PWD)/build/squashfs-root/usr/lib
	cp --force --recursive $(PWD)/build/usr/share/* $(PWD)/build/squashfs-root/usr/share

	export ARCH=x86_64 && bin/appimagetool.AppImage $(PWD)/build/squashfs-root $(PWD)/OnlyOffice.AppImage
	chmod +x $(PWD)/OnlyOffice.AppImage

clean:
	rm -rf $(PWD)/build

