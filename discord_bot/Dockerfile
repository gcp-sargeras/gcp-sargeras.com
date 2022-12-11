FROM ruby:2.7.2

RUN gem install bundler

RUN useradd bot
WORKDIR /home/bot

COPY ./Gemfile /home/bot/Gemfile
COPY ./Gemfile.lock /home/bot/Gemfile.lock

RUN bundle install

COPY . /home/bot

RUN chmod +x /home/bot/bin/start

RUN chown -R bot:bot /home/bot
RUN chown -R bot:bot /usr/local/bundle

USER bot
ENTRYPOINT [ "/home/bot/bin/start" ]