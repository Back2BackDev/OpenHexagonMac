#!/bin/bash

# This bash script, called in a repository with submodules, builds and installs all submodules then the project itself
# RELEASE MODE, SKIPS RPATH
# Takes $1 destination directory parameter

PROJECTNAME=${PWD##*/} # Project to build (current directory name)
BUILDTYPE="RELEASE" # Passed to CMake (CMAKE_BUILD_TYPE)
BUILDSHARED="TRUE" # Passed to CMake (LIBNAME_BUILD_SHARED_LIB)
MAKEJOBS="4" # make -j...

CMAKEFLAGS="-DCMAKE_BUILD_TYPE=$BUILDTYPE -DCMAKE_SKIP_BUILD_RPATH=TRUE"

export DESTDIR="$1/"
export CMAKE_PREFIX_PATH="$1/usr/local/"

echo "building for release"
echo "CMAKEFLAGS = $CMAKEFLAGS"
echo "DESTDIR = $DESTDIR"
echo "CMAKE_PREFIX_PATH = $CMAKE_PREFIX_PATH"

read -p "Continue? " -n 1
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

LIBS=("SSVJsonCpp" "SSVUtils" "SSVUtilsJson" "SSVMenuSystem" "SSVEntitySystem" "SSVLuaWrapper" "SSVStart") # List of extlibs to build in order

function warn() {
	echo "Error occured in: `pwd`"
	echo "Error was: "$@
}

function die() {
	status=$1; shift
	warn "$@" >&2
	exit $status
}

# Builds a lib, with name $1 - calls CMake, make -j and make install -j
function buildLib
{
	local LIBNAME="$1"

	echo "Building $LIBNAME..."
  	cd $LIBNAME # Enter lib main directory (where CMakeLists.txt is)
  	rm CMakeCache.txt # Remove CMakeCache.txt, in case an earlier (accidental) build was made in the main directory1
  	mkdir build; cd build # Create and move to the build directory
  	rm CMakeCache.txt # If the library was previously built, remove CMakeCache.txt

	# Run CMake, make and make install
	cmake ../ -DBUILD_SHARED_LIB=$BUILDSHARED $CMAKEFLAGS || \
		die 1 "cmake failed"

	make -j$MAKEJOBS || \
		die 1 "make failed"

	make install -j$MAKEJOBS || \
		die 1 "make install failed"

	cd ../.. # Go back to extlibs directory
	echo "Finished building $LIBNAME..."
}

cd extlibs  # Start building... Enter extlibs, and build extlibs
for LIB in ${LIBS[*]}; do buildLib $LIB; done
cd .. # Now we are in the main folder
echo "Building $PROJECTNAME..."
rm CMakeCache.txt # Remove CMakeCache.txt, in case an earlier (accidental) build was made in the main directory
mkdir build; cd build # Create and move to the build directory
rm CMakeCache.txt # If the library was previously built, remove CMakeCache.txt

## Run CMake, make and make install
cmake ../ $CMAKEFLAGS
make -j$MAKEJOBS; make install -j$MAKEJOBS

cd ..
echo "Finished building $PROJECTNAME..."
