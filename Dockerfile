# -*- mode: ruby -*-
# vi: set ft=ruby :

# docker run -i -t -p 8888:8888  -v $(pwd):/home/aqua/workspace/notebooks aquabiota/notebook-py2 jupyter notebook --ip='*' --port=8888  --no-browser
# docker run -i -t -p 8888:8888   aquabiota/notebook-py2 jupyter notebook  --ip='*' --port=8888  --no-browser

# MODIFIED FROM: https://github.com/ContinuumIO/docker-images/blob/master/anaconda3/Dockerfile
FROM aquabiota/notebook-base:latest

LABEL maintainer "Aquabiota Solutions AB <mapcloud@aquabiota.se>"

ARG DEBIAN_FRONTEND=noninteractive

USER $NB_USER
# NOTE. this will install the full anaconda but for python 2. Only for develop.
# Packages for production can be added in a yaml env file.
RUN conda create -y -n ipykernel_py2 python=2 ipykernel anaconda

RUN ["/bin/bash", "-c", "source activate ipykernel_py2 && python -m ipykernel install --user" ]

# Preparing Nansat install
# https://github.com/nansencenter/nansat
ENV GDAL_DATA $HOME/conda/share/gdal/
ENV GEOS_DIR $HOME/conda/

RUN conda install -n ipykernel_py2 -q --yes -c conda-forge nose pillow \
    basemap netcdf4 gdal geopy folium rasterio ipyleaflet bqplot cmocean \
    cartopy iris shapely pyproj

RUN conda install -n ipykernel_py2 -y bcrypt passlib

RUN ["/bin/bash", "-c", "source activate ipykernel_py2 && pip install pyorient"]
RUN ["/bin/bash", "-c", "source activate ipykernel_py2 && pip install https://github.com/nansencenter/nansat/archive/master.tar.gz"]

# Ensure that container starts with the Notebook_user
USER $NB_USER
