#!/bin/bash

current_dir=$(dirname ${0})
build_root=$(realpath $current_dir/rpmbuild)

# install yum-utils to get yum-builddep so that build dependencies are installed.
sudo yum install -y yum-utils rpm-build

# Make the default RPM build tree
mkdir -p $build_root/{BUILD,RPMS,SOURCES,SPECS,SRPMS,BUILDROOT}

# Copy the patch file to sources
cp *.patch $build_root/SOURCES/

# Copy dpec file to right place
cp *.spec $build_root/SPECS/

# Install build dependencies
sudo yum-builddep -y ./ruby.spec

# Download source without verifying it and use it to make the RPM
echo "Now building the RPM using rpmbuild."
rpmbuild --undefine=_disable_source_fetch --define="_topdir $build_root" --quiet -ba $build_root/SPECS/ruby.spec

if [ "$?" -ne "0" ]; then
    echo -e "\n\nIf you are running this in VirtualBox and see an error like 'Read-only file system @ rb_file_s_symlink',"
    echo -e "https://serverfault.com/a/367839 may be useful.\n\n"
else
    echo -e "\n\nRPMs available for installation:"
    find $build_root -name '*.rpm' -type f
fi
