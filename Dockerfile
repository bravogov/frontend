ARG ruby_version=4.0
ARG base_image=ghcr.io/alphagov/govuk-ruby-base:$ruby_version
ARG builder_image=ghcr.io/alphagov/govuk-ruby-builder:$ruby_version


FROM --platform=$TARGETPLATFORM $builder_image AS builder

WORKDIR $APP_HOME
COPY Gemfile* .ruby-version ./
RUN bundle install
COPY package.json yarn.lock ./
RUN npm install -g yarn@1.22.19 && yarn install --immutable
COPY . .
RUN bootsnap precompile --gemfile .
RUN rails assets:precompile && rm -fr log


FROM --platform=$TARGETPLATFORM $base_image

ENV GOVUK_APP_NAME=frontend

WORKDIR $APP_HOME
COPY --from=builder $BUNDLE_PATH $BUNDLE_PATH
COPY --from=builder $BOOTSNAP_CACHE_DIR $BOOTSNAP_CACHE_DIR
COPY --from=builder $APP_HOME .

# Keep the runtime fragment cache writable when Puma runs as the unprivileged app user.
USER root
RUN mkdir -p /tmp/cache && chown -R app:app /tmp/cache
USER app
CMD ["puma"]
