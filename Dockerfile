FROM ruby:2.7.5

ARG RAILS_ENV
ARG SECRET_KEY_BASE

# Necessary for bundler to operate properly
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# add nodejs and yarn dependencies for the frontend
# RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
#  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
#  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# --allow-unauthenticated needed for yarn package
RUN apt-get update && apt-get upgrade -y && \
  apt-get install --no-install-recommends -y ca-certificates nodejs \
  build-essential libpq-dev libreoffice imagemagick unzip ghostscript vim \
  libqt5webkit5-dev xvfb xauth default-jre-headless --fix-missing --allow-unauthenticated

RUN apt-get install chromium -y

# Increase stack size limit to help working with large works
ENV RUBY_THREAD_MACHINE_STACK_SIZE 8388608

RUN gem update --system

RUN mkdir /data
WORKDIR /data

# Pre-install gems so we aren't reinstalling all the gems when literally any
# filesystem change happens
ADD Gemfile /data
ADD Gemfile.lock /data
RUN mkdir /data/build
ADD ./build/install_gems.sh /data/build
RUN ./build/install_gems.sh

# Add the application code
ADD . /data

# install node dependencies, after there are some included
#RUN yarn install
