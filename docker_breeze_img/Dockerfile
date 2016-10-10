FROM fimm/django

# RUN apt-get install -y libffi-dev

# takes a very long time, so we moved it from requirements.txt to here, so that docker can commit (and thus use caching)
# for next build operations before doing this one
RUN pip install --no-cache-dir pandas>=0.13.1

WORKDIR ~
###
# creating required file system structure for Breeze
###
# logs
RUN mkdir -p /var/log/breeze
# user created data storage
RUN mkdir -p /projects/breeze
# alias for dev mode
RUN ln -s /projects/breeze /projects/breeze-dev
# alias for project storage, depending on breeze configuration
RUN mkdir /fs/
RUN ln -s /projects /fs/projects

# TEMP
RUN echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/2/Debian_8.0/ /' >> /etc/apt/sources.list.d/fish.list && \
    apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 2CE2AC08D880C8E4 && \
    apt-get update && \
    apt-get install -y fish

# shrinking the image
RUN apt-get -y autoremove
RUN apt-get -y autoclean

# replace any files/dir in the container with the ones from ./fs_override/
ADD fs_override /

RUN apt-get -y install openssh-client
