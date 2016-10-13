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

# installs fish and openssh (for docker compute)
RUN echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/2/Debian_8.0/ /' >> /etc/apt/sources.list.d/fish.list && \
    apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 2CE2AC08D880C8E4 && \
    apt-get update && \
    apt-get install -y --no-install-recommends fish openssh-client \
	&& apt-get -y autoclean && apt-get -y autoremove \
	&& rm -fr /var/cache/apt/archives/*

# Final cleanup, WARNING : THIS WILL BREAK APT
RUN rm -fr /var/lib/apt/lists/*	/tmp/*	/var/tmp/*

# replace any files/dir in the container with the ones from ./fs_override/
ADD fs_override /

