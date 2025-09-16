---
layout: default
title: Services
parent: Reference
nav_order: 5
permalink: /services
---

# Services

This document provides an overview of the services that are included in the Homelabeazy project.

## Core Infrastructure

These services are essential for the operation of your homelab. They provide core functionality such as routing, authentication, and secrets management.

| Service           | Description                                                                                             |
| ----------------- | ------------------------------------------------------------------------------------------------------- |
| **Traefik**       | A modern reverse proxy and load balancer that makes deploying microservices easy.                       |
| **Authelia**      | An open-source authentication and authorization server providing two-factor authentication and single sign-on. |
| **OpenLDAP**      | A lightweight directory access protocol for user authentication.                                        |
| **Vault**         | A tool for securely accessing secrets.                                                                  |
| **Velero**        | A tool for backing up and restoring your Kubernetes cluster resources and persistent volumes.           |
| **EFK Stack**     | A centralized logging solution consisting of Elasticsearch, Fluentd, and Kibana.                      |

## Applications

These are some of the applications that you can deploy to your homelab. You can find the ArgoCD application manifests for these applications in the `apps/` directory.

| Service           | Description                                                                                             |
| ----------------- | ------------------------------------------------------------------------------------------------------- |
| **AppFlowy**      | An open-source alternative to Notion.                                                                   |
| **Bitwarden**     | A self-hosted password manager.                                                                         |
| **Coder**         | A remote development environment that runs on your own infrastructure.                                  |
| **Gitea**         | A self-hosted Git service.                                                                              |
| **Grafana**       | A monitoring and observability platform.                                                                |
| **Guacamole**     | A clientless remote desktop gateway.                                                                    |
| **Home Assistant**| An open-source home automation platform.                                                                |
| **Homebox**       | A simple, a static homepage for your homelab.                                                           |
| **Jackett**       | A proxy server for torrent trackers.                                                                    |
| **Jellyfin**      | A self-hosted media server.                                                                             |
| **Jellyseerr**    | A request management and media discovery tool for Jellyfin.                                             |
| **Kasm**          | A container streaming platform for running desktops and applications in a browser.                      |
| **Kiwix**         | An offline reader for online content like Wikipedia.                                                    |
| **Langflow**      | A UI for experimenting with and prototyping language models.                                            |
| **Lidarr**        | A music collection manager for Usenet and BitTorrent users.                                             |
| **Linkwarden**    | A self-hosted, open-source collaborative bookmark manager.                                              |
| **MariaDB**       | A popular open-source relational database.                                                              |
| **Meilisearch**   | A fast, open-source, and powerful search engine.                                                        |
| **Metube**        | A web UI for youtube-dl.                                                                                |
| **Open WebUI**    | A user-friendly web interface for large language models.                                                |
| **Overseerr**     | A request management and media discovery tool for Plex.                                                 |
| **Perplexica**    | An open-source AI search engine.                                                                        |
| **pfSense**       | A powerful open-source firewall and router.                                                             |
| **Pi-hole**       | A network-wide ad blocker.                                                                              |
| **Plex**          | A self-hosted media server.                                                                             |
| **Portainer**     | A lightweight management UI for Docker, Swarm, Kubernetes, and ACI.                                     |
| **Postgres**      | A powerful, open-source object-relational database system.                                              |
| **Puter**         | A self-hosted cloud desktop.                                                                            |
| **qBittorrent**   | A lightweight BitTorrent client.                                                                        |
| **Radarr**        | A movie collection manager for Usenet and BitTorrent users.                                             |
| **Redis**         | An in-memory data structure store.                                                                      |
| **Sabnzbd**       | A binary newsreader for downloading from Usenet.                                                        |
| **SearXNG**       | A privacy-respecting, hackable metasearch engine.                                                       |
| **Sonarr**        | A PVR for Usenet and BitTorrent users.                                                                  |
| **Supabase**      | An open-source Firebase alternative.                                                                    |
| **Tailscale**     | A zero-config VPN for building secure networks.                                                         |
| **WireGuard**     | A fast, modern, and secure VPN tunnel.                                                                  |
