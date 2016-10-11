# Copyright (c) Jupyter Development Team.
# Author Luca Delucchi 2016 (OSGeo)
# Distributed under the terms of the Modified BSD License.
FROM debian:stretch

MAINTAINER Jupyter Project <jupyter@googlegroups.com>, OSGeo

USER root

# Install all OS dependencies for notebook server that starts but lacks all
# features (e.g., download as all possible file formats)
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -yq --no-install-recommends \
    wget \
    bzip2 \
    ca-certificates \
    sudo \
    locales \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# Install Tini
RUN wget --quiet https://github.com/krallin/tini/releases/download/v0.10.0/tini && \
    echo "1361527f39190a7338a0b434bd8c88ff7233ce7b9a4876f3315c22fce7eca1b0 *tini" | sha256sum -c - && \
    mv tini /usr/local/bin/tini && \
    chmod +x /usr/local/bin/tini

# Configure environment
ENV CONDA_DIR /opt/conda
ENV PATH $CONDA_DIR/bin:$PATH
ENV SHELL /bin/bash
ENV NB_USER jovyan
ENV NB_UID 1000
ENV HOME /home/$NB_USER
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Create jovyan user with UID=1000 and in the 'users' group
RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    mkdir -p $CONDA_DIR && \
    chown $NB_USER $CONDA_DIR

USER $NB_USER

# Setup jovyan home directory
RUN mkdir /home/$NB_USER/work && \
    mkdir /home/$NB_USER/.jupyter && \
    mkdir -p -m 700 /home/$NB_USER/.local/share/jupyter && \
    echo "cacert=/etc/ssl/certs/ca-certificates.crt" > /home/$NB_USER/.curlrc

# Install conda as jovyan
RUN cd /tmp && \
    mkdir -p $CONDA_DIR && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.1.11-Linux-x86_64.sh && \
    echo "efd6a9362fc6b4085f599a881d20e57de628da8c1a898c08ec82874f3bad41bf *Miniconda3-4.1.11-Linux-x86_64.sh" | sha256sum -c - && \
    /bin/bash Miniconda3-4.1.11-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
    rm Miniconda3-4.1.11-Linux-x86_64.sh && \
    $CONDA_DIR/bin/conda install --quiet --yes conda==4.1.11 && \
    $CONDA_DIR/bin/conda config --system --add channels conda-forge && \
    $CONDA_DIR/bin/conda config --system --set auto_update_conda false && \
    conda clean -tipsy

# Temporary workaround for https://github.com/jupyter/docker-stacks/issues/210
# Stick with jpeg 8 to avoid problems with R packages
RUN echo "jpeg 8*" >> /opt/conda/conda-meta/pinned

# Install Jupyter notebook as jovyan
RUN conda install --quiet --yes \
    'notebook=4.2*' \
    && conda clean -tipsy

# Install JupyterHub to get the jupyterhub-singleuser startup script
RUN pip --no-cache-dir install 'jupyterhub==0.5'

USER root

EXPOSE 8888
WORKDIR /home/$NB_USER/work

# Configure container startup
ENTRYPOINT ["tini", "--"]
CMD ["start-notebook.sh"]

# Add local files as late as possible to avoid cache busting
COPY start.sh /usr/local/bin/
COPY start-notebook.sh /usr/local/bin/
COPY start-singleuser.sh /usr/local/bin/
COPY jupyter_notebook_config.py /home/$NB_USER/.jupyter/
RUN chown -R $NB_USER:users /home/$NB_USER/.jupyter

# Install all OS dependencies for fully functional notebook server
RUN apt-get update && apt-get install -yq --no-install-recommends \
    git \
    vim \
    jed \
    emacs \
    build-essential \
    python-dev \
    unzip \
    libsm6 \
    pandoc \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-fonts-extra \
    texlive-fonts-recommended \
    texlive-generic-recommended \
    libxrender1 \
    inkscape \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*


############# This is the only code needed when base-notebook will be based on debian stretch 

# libav-tools for matplotlib anim
RUN apt-get update && \
    apt-get install -y --no-install-recommends libav-tools \
    apt-utils \
    xterm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install all geospatial packages for python 2
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python-pip \
    python-setuptools \
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

# Install all geospatial packages python 3
RUN apt-get update && \
    apt-get install -y --no-install-recommends python3-fiona \
    python3-gdal \
    python3-rasterio \
    python3-shapely \
    python3-pdal \
    python3-osmapi \
    python3-overpass \
    python3-overpy && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN python2 -m pip install ipykernel
RUN python2 -m ipykernel install

### Install GRASS trunk, when grass 72 will be available we can switch to it ###

#RUN apt-get update && \
#    apt-get install -y --no-install-recommends grass \
#    grass-dev && \
#    apt-get clean && \
#    rm -rf /var/lib/apt/lists/*


RUN apt-get update && \
    apt-get install -y --no-install-recommends subversion \
    build-essential \
    flex \
    bison \
    libncurses5-dev \
    zlib1g-dev \
    libjpeg-dev \
    libgdal-dev \
    libtiff-dev \
    libgcc1 \
    gettext \
    libfreetype6-dev \
    libreadline-dev \
    libxmu-dev \
    make \
    python-dev \
    swig \
    sqlite3 \
    fftw3-dev \
    libsqlite3-dev \
    mesa-common-dev \
    libglu1-mesa-dev \
    libcairo2-dev \
    netcdf-bin \
    proj-bin \
    gdal-bin \
    tcl-dev tk-dev libavcodec-dev python-wxversion libavutil-dev \
    virtualenv \
    python3-virtualenv \
    python-virtualenv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
COPY grass-compile.sh /usr/local/bin/

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python-numpy \
    python3-numpy

RUN grass-compile.sh

# copy GRASS startup to binaries directory
COPY start-grass.sh /usr/local/bin/
COPY update-notebook.sh /usr/local/bin/

ENV TERM xterm

USER $NB_USER    

RUN conda create --quiet --yes -p $CONDA_DIR/envs/python2 python=2.7 \
    psutil \
    cartopy \
    folium \
    iris \
    pysal

RUN conda install --quiet --yes \
    psutil \
    cartopy \
    folium \
    iris \
    pysal

# Add shortcuts to distinguish pip for python2 and python3 envs
RUN ln -s $CONDA_DIR/envs/python2/bin/pip $CONDA_DIR/bin/pip2 && \
    ln -s $CONDA_DIR/bin/pip $CONDA_DIR/bin/pip3

# Configure ipython kernel to use matplotlib inline backend by default
RUN mkdir -p $HOME/.ipython/profile_default/startup
COPY mplimporthook.py $HOME/.ipython/profile_default/startup/

# download and move to work directory OSGeoLive-Notebooks
RUN git clone https://github.com/OSGeo/OSGeoLive-Notebooks.git /home/$NB_USER/work/

WORKDIR /home/$NB_USER/work/

RUN git clone https://github.com/wenzeslaus/python-grass-addon.git
RUN git clone https://github.com/zarch/workshop-pygrass.git

# create directories and download North Carolina dataset
WORKDIR /home/$NB_USER/
RUN mkdir -p /home/$NB_USER/grassdata
WORKDIR /home/$NB_USER/grassdata
RUN wget -c https://grass.osgeo.org/sampledata/north_carolina/nc_spm_08_grass7.tar.gz
RUN tar xzf nc_spm_08_grass7.tar.gz
RUN rm -f nc_spm_08_grass7.tar.gz

WORKDIR /home/$NB_USER/work

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_USER
