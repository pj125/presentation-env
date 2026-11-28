# presentation-env
To create presentation with help of AI

This repository provides a containerised [Slidev](https://sli.dev) environment for
writing presentations in Markdown. Only a container engine is required on the host:
[Podman](https://podman.io) (including Podman Desktop on Windows) or Docker.
All `docker` commands below work the same with `podman`.

## Layout

```
Dockerfile                  # Image with the Slidev CLI and default theme
docker-compose.yml          # Runs the Slidev dev server on port 3030
.devcontainer/              # VS Code Dev Container / GitHub Codespaces config
templates/slides.md         # Template used for new presentations
presentations/<name>/       # One folder per presentation (entry file: slides.md)
scripts/new-presentation.sh # Creates a new presentation from the template (Linux/macOS)
scripts/new-presentation.ps1 # Same for Windows PowerShell
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

## Podman on Windows (Podman Desktop)

Run these commands in PowerShell from the repository root.

1. In Podman Desktop, make sure a Podman machine is created and running
   (or run `podman machine init` once, then `podman machine start`).
2. Build the image:

   ```powershell
   podman build -t presentation-env-slidev .
   ```

3. Create a new presentation:

   ```powershell
   .\scripts\new-presentation.ps1 my-talk
   ```

   If scripts are blocked by the execution policy, run
   `powershell -ExecutionPolicy Bypass -File .\scripts\new-presentation.ps1 my-talk`.

4. Start the dev server and open http://localhost:3030:

   ```powershell
   podman run --rm -it -p 3030:3030 `
     -v "${PWD}\presentations:/presentations" `
     -w /presentations/my-talk `
     -e CHOKIDAR_USEPOLLING=true `
     presentation-env-slidev
   ```

   Press `Ctrl+C` to stop it.

### Using `podman compose`

`podman compose` needs a compose provider. In Podman Desktop, go to
**Settings → Resources → Compose** and install it. Then run:

```powershell
$env:PRESENTATION = "my-talk"   # omit to serve the example
podman compose up --build
```

To build a static site with Podman:

```powershell
$env:PRESENTATION = "my-talk"
podman compose run --rm slidev slidev build slides.md
```

### Troubleshooting

- **`self-signed certificate in certificate chain` during the build**: a
  company proxy is inspecting HTTPS traffic. Copy your company root CA
  (`.crt`, PEM format) into the repository, and in the `Dockerfile` add
  `COPY company-ca.crt /usr/local/share/company-ca.crt` and
  `ENV NODE_EXTRA_CA_CERTS=/usr/local/share/company-ca.crt` before the
  `RUN npm install` line.
- **Edits are not picked up**: keep `CHOKIDAR_USEPOLLING=true`. File change
  events do not reach the container through Windows mounts.
- **Linux hosts with SELinux** (Fedora/RHEL): append `:Z` to the volume, e.g.
  `-v ./presentations:/presentations:Z`.

## Dev Container

Open the repository in VS Code with the Dev Containers extension (or in GitHub
Codespaces). To use Podman instead of Docker, set the VS Code user setting
`"dev.containers.dockerPath": "podman"`. Then run inside the container:

```sh
cd presentations/example && slidev slides.md --remote
```
