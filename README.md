# presentation-env
To create presentation with help of AI

This repository provides a containerised [Slidev](https://sli.dev) environment for
writing presentations in Markdown. Only Docker is required on the host.

## Layout

```
Dockerfile                  # Image with the Slidev CLI and default theme
docker-compose.yml          # Runs the Slidev dev server on port 3030
.devcontainer/              # VS Code Dev Container / GitHub Codespaces config
templates/slides.md         # Template used for new presentations
presentations/<name>/       # One folder per presentation (entry file: slides.md)
scripts/new-presentation.sh # Creates a new presentation from the template
```

## Quick start

```sh
# Serve the example presentation at http://localhost:3030
docker compose up --build
```

## Create a new presentation

```sh
scripts/new-presentation.sh my-talk
PRESENTATION=my-talk docker compose up
```

Edit `presentations/my-talk/slides.md`; the browser reloads automatically.
Use a different host port with `SLIDEV_PORT=8080`.

Useful URLs while the server is running:

- Slides: http://localhost:3030/
- Presenter mode: http://localhost:3030/presenter/
- Overview: http://localhost:3030/overview/

## Build a static site

```sh
PRESENTATION=my-talk docker compose run --rm slidev slidev build slides.md
```

The output is written to `presentations/my-talk/dist/`.

## Dev Container

Open the repository in VS Code with the Dev Containers extension (or in GitHub
Codespaces), then run inside the container:

```sh
cd presentations/example && slidev slides.md --remote
```
