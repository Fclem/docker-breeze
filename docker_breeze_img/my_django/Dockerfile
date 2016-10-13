FROM django:python2

# ?
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

###
# installing the application dependencies / python libs
###
# pip install
ONBUILD COPY requirements.txt /usr/src/app/
ONBUILD RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r requirements.txt

# installing some other importants packages
RUN apt-get update && apt-get upgrade -y && \
	apt-get install -y --no-install-recommends \
		r-base r-base-dev \
		libffi-dev \
		gcc \
		gettext \
		mysql-client libmysqlclient-dev \
		sqlite3 \
	&& apt-get -y autoclean && apt-get -y autoremove && \
	rm -fr /var/cache/apt/archives/* && rm -fr /var/lib/apt/lists/* 

EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
