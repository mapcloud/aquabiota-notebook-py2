# -*- mode: ruby -*-
# vi: set ft=ruby :

#  docker run -i -t -p 8888:8888  -v $(pwd):/opt/notebooks   aquabiota/notebook-py2 jupyter notebook --notebook-dir=/opt/notebooks --ip='*' --port=8888  --allow-root  --no-browser

# MODIFIED FROM: https://github.com/ContinuumIO/docker-images/blob/master/anaconda3/Dockerfile
FROM aquabiota/notebook-base:latest

LABEL maintainer "Aquabiota Solutions AB <mapcloud@aquabiota.se>"

USER $NB_USER
RUN conda create -y -n ipykernel_py2 python=2 ipykernel

RUN ["/bin/bash", "-c", "source activate ipykernel_py2 && python -m ipykernel install --user" ]

USER $NB_USER
