svn co https://svn.osgeo.org/grass/grass/trunk/ grass_trunk

cd grass_trunk

./configure \
    --enable-64bit \
    --with-sqlite \
    --with-cairo \
    --with-gdal=/usr/bin/gdal-config \
    --with-python=/usr/bin/python-config \
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
