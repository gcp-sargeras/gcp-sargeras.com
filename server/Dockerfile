FROM ruby:2.7.1-alpine

RUN apk add --no-cache --update build-base \
  linux-headers \
  git \
  postgresql-dev \
  nodejs \
  tzdata

RUN gem install bundler

RUN adduser --home /home/rails -s /bin/bash --disabled-password rails
WORKDIR /home/rails

COPY ./Gemfile /home/rails/Gemfile

RUN bundle install --jobs $(nproc)

COPY . /home/rails

COPY --from=cooljacob204/simc /app/SimulationCraft/simc /home/rails/bin/simc

RUN chown -R rails:rails /home/rails

USER rails

RUN chmod +x /home/rails/bin/simc

CMD [ "rails", "s", "-b", "0.0.0.0" ]