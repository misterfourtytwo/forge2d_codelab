# Simple Gin static http server

Template which serves static files from `./static` directory.
After git clone, symlink your static files into `./static` directory. (For flutter that would be `build/web` directory)

```bash
ln -s path_to_your_static_files ./static
```

## Run

```bash
go run main.go
# OR
./start.sh
```

## Visit

Visit http://localhost:4242
