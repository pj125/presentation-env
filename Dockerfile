# Container image for creating and presenting slides with Slidev (https://sli.dev)
# Fully-qualified name so the image also builds with Podman (no short-name resolution)
FROM docker.io/library/node:22-bookworm-slim

ARG SLIDEV_VERSION=53.2.0
ARG SLIDEV_THEME_DEFAULT_VERSION=0.25.0

RUN npm install -g \
        @slidev/cli@${SLIDEV_VERSION} \
        @slidev/theme-default@${SLIDEV_THEME_DEFAULT_VERSION} \
    && npm cache clean --force

WORKDIR /presentations

EXPOSE 3030

# Entry markdown file of the presentation (relative to the working directory)
ENV SLIDES=slides.md

# --remote makes the dev server listen on all interfaces so it is reachable from the host
CMD ["sh", "-c", "exec slidev \"$SLIDES\" --remote --port 3030"]
