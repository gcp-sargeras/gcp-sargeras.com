FROM ruby:2.7.2

RUN gem install bundler

RUN mkdir /bot

WORKDIR /bot

COPY ./Gemfile /bot/Gemfile

RUN bundle install --without development test

COPY . /bot

RUN chmod +x /bot/bin/start

RUN useradd bot
USER bot

ENTRYPOINT [ "/bot/bin/start" ]