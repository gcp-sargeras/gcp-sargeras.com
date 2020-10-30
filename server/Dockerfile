FROM ruby:2.7.1

RUN gem install bundler

RUN useradd --create-home --shell /bin/bash rails
WORKDIR /home/rails

COPY ./Gemfile /home/rails/Gemfile

RUN bundle install

COPY . /home/rails

RUN chown -R rails:rails /home/rails

USER rails

CMD [ "rails", "s", "-b", "0.0.0.0" ]