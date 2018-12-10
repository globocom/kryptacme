FROM tuxmonteiro/ruby:centos7

MAINTAINER Marcelo Teixeira Monteiro (tuxmonteiro)

ARG ruby_ver=2.3.6
ENV RUBY_ENV=${ruby_ver}
ENV PATH "${PATH}:/usr/local/rvm/rubies/ruby-${RUBY_ENV}/bin"
ENV RAILS_ENV production
ENV KRYPTACME_DATABASE_USER root
ENV KRYPTACME_DATABASE_HOST 127.0.0.1
ENV KRYPTACME_DATABASE_PASSWORD password
ENV SECRET_KEY_BASE ac78b90016cdfd18801e08b146c2eb69d6bac46d44009259e9ccf9abe982f16fe8c745d8881538ca9dba2d5b0f9daf459db3c54d4a609b888b56703b3a81caeb

RUN yum clean all; yum install -y bind-utils git \
    && groupadd -g 12345 kryptacme; useradd -m -u 12345 -g kryptacme -d /home/kryptacme kryptacme \
    && chown -R kryptacme.kryptacme /usr/local/rvm/gems/ruby-${RUBY_ENV} \
    && echo 'kryptacme ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

USER kryptacme

WORKDIR /home/kryptacme

ADD docker/start.sh /usr/bin/

RUN curl -Lk https://codeload.github.com/globocom/kryptacme/tar.gz/master | tar xzv \
    && mv kryptacme-master app \
    && cd /home/kryptacme/app \
    && source /usr/local/rvm/environments/ruby-${RUBY_ENV}@global \
    && rm -rf vendor; bundle install --deployment --without=test,development

WORKDIR /home/kryptacme/app

CMD ["/usr/bin/start.sh"]
