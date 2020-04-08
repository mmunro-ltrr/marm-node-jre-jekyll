FROM debian:buster-20200327-slim as fulldevenv

WORKDIR /build

COPY Gemfile Gemfile.lock /build/

RUN apt-get update \
  && apt-get install -y \
    git \
    ruby-dev \
    gcc \
    g++ \
    make \
    libc6-dev \
    zlib1g-dev \
  && rm -rf /var/lib/apt/lists/* \
  && gem install -N bundler -v 1.17.3 \
  && bundle install --deployment

FROM node:12.16.1-buster-slim

ENV LANG C.UTF-8
ENV JAVA_HOME /usr/local/openjdk-11
ENV PATH ${JAVA_HOME}/bin:${PATH}

COPY --from=fulldevenv /build /rubytooling/
COPY --from=openjdk:11.0.6-jre-slim-buster "$JAVA_HOME" "$JAVA_HOME"
COPY --from=openjdk:11.0.6-jre-slim-buster /etc/ca-certificates/update.d/docker-openjdk /etc/ca-certificates/update.d/docker-openjdk

RUN apt-get update \
  && apt-get install --no-install-recommends -y \
    git \
    jq \
    python3 \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    ruby \
  && rm -rf /var/lib/apt/lists/* \
  && gem install -N bundler -v 1.17.3 \
  && bundle config gemfile '/rubytooling/Gemfile' \
  && pip3 install 'awscli~=1.18.37'; \
  find "${JAVA_HOME}/lib" -name '*.so' -exec dirname '{}' ';' | sort -u > /etc/ld.so.conf.d/docker-openjdk.conf; \
	ldconfig
