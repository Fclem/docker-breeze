FROM django:python2

# ?
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

###
# installing the application dependencies / python libs
###
ONBUILD RUN apt-get update && apt-get install -y r-base r-base-dev
# pip install
ONBUILD COPY requirements.txt /usr/src/app/
ONBUILD RUN pip install --no-cache-dir -r requirements.txt

# ONBUILD COPY . /usr/src/app

# installing some other importants packages
RUN apt-get update && apt-get upgrade -y && apt-get update && apt-get install -y \
		libffi-dev \
		gcc \
		gettext \
		mysql-client libmysqlclient-dev \
		sqlite3 \
	--no-install-recommends && rm -rf /var/lib/apt/lists/*

# clears what might already be cached
RUN apt-get autoremove
RUN apt-get autoclean
# RUN rm -rf /var/cache/apt/archives

# tells aptitude not to cache anything # broken : APT will store *.deb at /
#RUN echo "Dir::Cache \"\";">>/etc/apt/apt.conf.d/02nocache
#RUN echo "Dir::Cache::archives \"\";">>/etc/apt/apt.conf.d/02nocache

EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
