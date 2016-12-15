FROM fimm/django

# takes a very long time, so we moved it from requirements.txt to here, so that docker can commit (and thus use caching)
# for next build operations before doing this one
RUN pip install --no-cache-dir pandas>=0.13.1

WORKDIR ~
###
# creating required file system structure for Breeze
###
# logs
RUN mkdir -p /var/log/breeze	/projects/breeze	/fs/ && \
	ln -s /projects/breeze /projects/breeze-dev && \
	ln -s /projects /fs/projects

# installs fish, openssh (for docker compute), git, maria-db client, 
RUN echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/2/Debian_8.0/ /' >> /etc/apt/sources.list.d/fish.list && \
    apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 2CE2AC08D880C8E4 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
	fish \
	openssh-client \
	git

# R related stuff
RUN apt-get install -y --no-install-recommends \
	libmariadb-client-lgpl-dev \
	r-cran-rjson

# custom R library installer
ADD https://raw.githubusercontent.com/Fclem/docker-Rcompute-env/master/_res/root_source/res/lib_installer.R /res/
# pyrasite relateder-Rcompute-env/master/_res/root_source/res/lib_installer.R /res/
# list of R libs to install
ADD lib_list /res/
# install all remaining R libraries
RUN ["R", "-e", "source('/res/lib_installer.R'); packages('/res/lib_list')"]

# RUN apt-get install -y --no-install-recommends \
#	python-dbg python-pycallgraph python-gobject-2-dev gir1.2-webkit-3.0 cython python-psutil \
#	build-essential libssl-dev libffi-dev \
#	libxml2-dev libxslt1-dev zlib1g-dev \
#	python-pip python-setuptools

#RUN apt-get install -y --no-install-recommends cython Cython
# replace any files/dir in the container with the ones from ./fs_override/
ADD fs_override /

# pyrasite related
#ADD https://pypi.python.org/packages/8e/d0/507f2bd9a6f9e9b475e0f62f04eeda72eeb920a79f2cc28a6a8c402e4550/pyrasite-2.0.tar.gz /res/
#ADD https://pypi.python.org/packages/66/79/f5e2aa7b85261bf5ae75de23f5361735a98f9527e71d194aae348756605d/pyrasite-gui-2.0beta7.tar.gz /res/
#ADD https://pypi.python.org/packages/98/c6/7fa12062ddfe1732d43b34b64a3fe99da958a88fa1d8b7550fe386a9ca01/meliae-0.4.0.tar.gz /res/
#RUN cd /res/ && md5sum -c sum.md5 && \
#	tar -xvf pyrasite-2.0.tar.gz && cd pyrasite-2.0 && python setup.py build && python setup.py install
# && cd /res/ && \
#	tar -xvf pyrasite-gui-2.0beta7.tar.gz && cd pyrasite-gui-2.0beta7 && python setup.py build && python setup.py install
#	tar -xvf meliae-0.4.0.tar.gz && cd meliae-0.4.0 && python setup.py build && python setup.py install && cd /res/ && \

RUN apt-get install -y --no-install-recommends slurm-drmaa1

RUN pip install --no-cache-dir drmaa>=0.5

# Final cleanup, WARNING : THIS WILL BREAK APT
RUN apt-get -y autoclean && apt-get -y autoremove \
	&& rm -fr /var/cache/apt/archives/*	/var/lib/apt/lists/*	/tmp/*	/var/tmp/*

# Add keys needed for verifying git commits
RUN gpg --keyserver pgp.mit.edu --recv-keys 0xB4A7FF8614ED9842 0xDFDAF03DA18C9EE8 && echo "trusted-key 0xB4A7FF8614ED9842">>~/.gnupg/gpg.conf && \
	echo "trusted-key 0xDFDAF03DA18C9EE8">>~/.gnupg/gpg.conf && mkdir ~/.ssh
RUN touch ~/.ssh/known_hosts && echo "github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==">>~/.ssh/known_hosts

RUN groupadd -g 876916667 sg_breeze_pharma && useradd -c 'breeze user' -u 8585873 -g 876916667 -G sudo  -m -d /home/breeze -s /bin/bash breeze && \
	mkdir -p /var/log/breeze && chown breeze /var/log/breeze && umask 0007
# RUN chown -R node.node /src
USER breeze
ENV HOME /home/breeze

