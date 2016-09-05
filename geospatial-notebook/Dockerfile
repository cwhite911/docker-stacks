# Copyright (c) Jupyter Development Team.
# Author Luca Delucchi 2016 (OSGeo)
# Distributed under the terms of the Modified BSD License.
FROM jupyter/minimal-notebook

MAINTAINER Jupyter Project <jupyter@googlegroups.com>, OSGeo

USER root

# libav-tools for matplotlib anim
RUN apt-get update && \
    apt-get install -y --no-install-recommends libav-tools \
    git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER $NB_USER

# Install all geospatial packages
RUN apt-get install -y --no-install-recommends grass \
    grass-dev \
    python-gdal \
    python-rasterio \
    python-shapely \
    python-fiona \
    python-geopandas \
    python-mapnik \
    python-pdal \
    python-pyproj \
    python-pysal \
    python-osmapi \
    python-overpass \
    python-overpy \
    python-mapscript \
    python-owslib && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


RUN apt-get install -y --no-install-recommends python3-fiona \
    python3-gdal \
    python3-rasterio \
    python3-shapely \
    python3-pdal \
    python3-osmapi \
    python3-overpass \
    python3-overpy && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
    
# Add shortcuts to distinguish pip for python2 and python3 envs
RUN ln -s $CONDA_DIR/envs/python2/bin/pip $CONDA_DIR/bin/pip2 && \
    ln -s $CONDA_DIR/bin/pip $CONDA_DIR/bin/pip3

# Configure ipython kernel to use matplotlib inline backend by default
RUN mkdir -p $HOME/.ipython/profile_default/startup
COPY mplimporthook.py $HOME/.ipython/profile_default/startup/

USER root

# Install Python 2 kernel spec globally to avoid permission problems when NB_UID
# switching at runtime.
RUN $CONDA_DIR/envs/python2/bin/python -m ipykernel install

# download and move to work directory OSGeoLive-Notebooks
WORKDIR /tmp

git clone https://github.com/OSGeo/OSGeoLive-Notebooks.git

RUN mv OSGeoLive-Notebooks/* /home/$NB_USER/work/
RUN rm -rf OSGeoLive-Notebooks/

# create directories and download North Carolina dataset
WORKDIR /home/$NB_USER/
RUN mkdir -p /home/$NB_USER/grassdata
WORKDIR /home/$NB_USER/grassdata
RUN wget -c https://grass.osgeo.org/sampledata/north_carolina/nc_spm_08_grass7.tar.gz
RUN tar xzf nc_spm_08_grass7.tar.gz
RUN rm -f nc_spm_08_grass7.tar.gz

# copy GRASS startup to binaries directory
COPY start-grass.sh /usr/local/bin/

USER $NB_USER
