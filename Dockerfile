FROM ruby:2.3.8
MAINTAINER "compras_dockerizing"
RUN apt-get update -qq && apt-get install -y build-essential imagemagick libmagickwand-dev libpq-dev nodejs postgresql-client g++ qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x
RUN mkdir /compras
WORKDIR /compras
COPY Gemfile /compras/Gemfile
COPY Gemfile.lock /compras/Gemfile.lock
RUN gem install bundler -v '1.17.3'
RUN export LANG=C.UTF-8 && gem install rmagick -v '2.13.4'
RUN bundle install
COPY . /compras
EXPOSE 3000

#CMD ["rails", "server", "-b", "0.0.0.0"]