FROM debian:latest

MAINTAINER Christian Lange
# Install runtime dependencies
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      #  ca-certificates \
        bzip2 \
        unzip \
        libfontconfig \
        python \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
 

# Install official PhantomJS release
# Install dumb-init (to handle PID 1 correctly).
# https://github.com/Yelp/dumb-init
# Runs as non-root user.
# Cleans up.

#RUN set -x  \
#&& apt-get update \
#&& apt-get install -y --no-install-recommends \
#       curl \
#&& mkdir /tmp/phantomjs \
#&& curl -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-${PHANTOM_JS_VERSION}.tar.bz2 \
#       | tar -xj --strip-components=1 -C /tmp/phantomjs \
#&& mv /tmp/phantomjs/bin/phantomjs /usr/local/bin \
#&& apt-get purge --auto-remove -y \
#       curl \
#&& apt-get clean \
##&& rm -rf /tmp/* /var/lib/apt/lists/* \
##&& useradd --system --uid 52379 -m --shell /usr/sbin/nologin phantomjs \
#&& su phantomjs -s /bin/sh -c "phantomjs --version"
#RUN  mkdir /app 

COPY ./app /app
##COPY ./casperjs-1.1.4-1.zip /tmp/casperjs

#RUN cd /tmp/phantomjs \ 
RUN cd /app \
&& unzip /app/casperjs-1.1.4-1.zip \ 
&& tar -xjf  /app/phantomjs-2.1.1-linux-x86_64.tar.bz2  \
&& ln -sf /app/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs \
&& ln -sf /app/casperjs-1.1.4-1/bin/casperjs /usr/local/bin/casperjs \
&& useradd --system --uid 52379 -m --shell /usr/sbin/nologin phantomjs \
# Clean up
&& rm /app/*.zip \ 
&& rm /app/*.tar.bz2 

WORKDIR /app/tests

 
#&& unzip
USER phantomjs


EXPOSE 8910

CMD ["bash"]

#docker run -it --rm --user 0 -v "$(pwd)"/app:/tests uit
