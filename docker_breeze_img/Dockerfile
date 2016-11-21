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
# list of R libs to install
ADD lib_list /res/
# install all remaining R libraries
RUN ["R", "-e", "source('/res/lib_installer.R'); packages('/res/lib_list')"]

# Final cleanup, WARNING : THIS WILL BREAK APT
RUN apt-get -y autoclean && apt-get -y autoremove \
	&& rm -fr /var/cache/apt/archives/*	/var/lib/apt/lists/*	/tmp/*	/var/tmp/*

# replace any files/dir in the container with the ones from ./fs_override/
ADD fs_override /

# Add keys needed for verifying git commits
RUN gpg --keyserver pgp.mit.edu --recv-keys 0xB4A7FF8614ED9842 0xDFDAF03DA18C9EE8 && echo "trusted-key 0xB4A7FF8614ED9842">>~/.gnupg/gpg.conf && \
	echo "trusted-key 0xDFDAF03DA18C9EE8">>~/.gnupg/gpg.conf && mkdir ~/.ssh
RUN touch ~/.ssh/known_hosts && echo "github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==">>~/.ssh/known_hosts
