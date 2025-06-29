# Inception

A Docker-based infrastructure project featuring NGINX, WordPress, MariaDB, and Redis containers.

## About

This project was completed on a VPS instead of the typical local VM setup. The infrastructure includes:
- NGINX web server with SSL/TLS
- WordPress CMS with php-fpm
- MariaDB database
- Redis object caching
- Hugo static site generator

## VPS Setup Guide

If you want to do this project on a VPS like I did, check out this guide: https://github.com/erdelp/inception-tuto

## SSH Configuration

For easy VPS access via VS Code SSH extension or terminal, add this to your `~/.ssh/config`:

```
Host inception
    HostName <server-ip>
    User login42
    Port 4242
    IdentityFile ~/.ssh/id_rsa
    ForwardX11 yes
    ForwardX11Trusted yes
```

Then simply use:
```bash
ssh inception
```

Or connect directly through VS Code with the Remote-SSH extension which I highly recommend.