#!/bin/bash

ZIP_NAME='cleanup_rancher.zip'

# Crete the build directory
rm $ZIP_NAME
rm -rf build
mkdir build

# Copy the sources
cp handler.py build/
cp -r env/lib/python3.6/site-packages/requests* build/

# Create zip directory
cd build
zip -r "../../../files/${ZIP_NAME}" *

# clean up
cd ..

rm -rf build