# Ansible Role: asuswrt

This role configures an ASUSWRT-based router.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
asuswrt_hostname: "asus"
```

The hostname to set on the router.

```yaml
asuswrt_wifi_config: []
```

A list of Wi-Fi networks to configure. See `defaults/main.yml` for an example.

```yaml
asuswrt_dhcp_static_leases: []
```

A list of DHCP static leases to configure. See `defaults/main.yml` for an example.

```yaml
asuswrt_port_forwards: []
```

A list of port forwards to configure. See `defaults/main.yml` for an example.

## Dependencies

None.

## Example Playbook

```yaml
- hosts: routers
  roles:
    - asuswrt
```

## License

MIT
