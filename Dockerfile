FROM ruby:3.2.2

RUN apt-get update && apt-get install -y \
        libvips \
        imagemagick

WORKDIR /imgbbs2

COPY Gemfile Gemfile.lock ./
RUN bundle
COPY . .

ENTRYPOINT ["bash", "/imgbbs2/entrypoint.sh"]

CMD ["rails", "s", "-b", "0.0.0.0"]
