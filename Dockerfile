FROM ubuntu:22.04 AS sqlite-builder

RUN apt-get update && apt-get install -y wget unzip
RUN wget -q https://www.sqlite.org/2026/sqlite-tools-linux-x64-3510200.zip && \
    unzip sqlite-tools-linux-x64-3510200.zip

FROM ruby:3.4.6

WORKDIR /rails

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test"

RUN apt-get update && apt-get install -y openssh-client

COPY --from=sqlite-builder /sqlite3_rsync /usr/local/bin/
RUN chmod +x /usr/local/bin/sqlite3_rsync

COPY Gemfile Gemfile.lock ./
RUN bundle install && echo "cache bust v2"

COPY . .
RUN SECRET_KEY_BASE=dummy_for_build bundle exec rails assets:precompile

RUN mkdir -p storage

EXPOSE 3000
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
