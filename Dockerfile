FROM ruby:3.2.0-alpine3.17

RUN apk add --no-cache --update build-base \
  linux-headers \
  git \
  postgresql-dev \
  nodejs \
  tzdata \
  vim

RUN gem install bundler

RUN adduser --home /home/rails -s /bin/bash --disabled-password rails
WORKDIR /home/rails

COPY --chown=rails:rails ./Gemfile /home/rails/Gemfile
COPY --chown=rails:rails ./Gemfile.lock /home/rails/Gemfile.lock

RUN bundle install --jobs $(nproc)

COPY --chown=rails:rails . /home/rails

COPY --chown=rails:rails --from=simulationcraftorg/simc:latest /app/SimulationCraft/simc /usr/local/bin/simc
RUN chmod +x /usr/local/bin/simc

RUN chown -R rails:rails /usr/local/bundle

USER rails

CMD [ "ruby", "--jit", "bin/rails", "s", "-b", "0.0.0.0" ]