#!/bin/bash

virtualenv --system-site-packages --python=/usr/bin/python2 ~/venv2
source ~/venv2/bin/activate

cd ~/venv2

svn co https://svn.osgeo.org/grass/grass/trunk/ grass_trunk

cd grass_trunk

./configure \
    --enable-64bit \
    --with-sqlite \
    --with-cairo \
    --with-gdal=/usr/bin/gdal-config \
    --with-python=/usr/bin/python2-config \
    --with-cxx \
    --with-freetype=yes \
    --enable-largefile=yes \
    --with-nls \
    --with-freetype-includes=/usr/include/freetype2 \
    --with-geos=yes \
    --with-blas \
    --with-lapack \
    --with-netcdf \
    --with-readline \
    --with-pthread \
    
make -j$(nproc) && sudo make install && sudo ldconfig

rm -rf grass_trunk

source deactivate

chown -R $NB_USER ~/venv2
