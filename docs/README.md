# Homelabeazy Documentation

This directory contains the source code for the Homelabeazy documentation site. The site is built with [Jekyll](https://jekyllrb.com/) and uses the [Chirpy](https://github.com/cotes2020/jekyll-theme-chirpy) theme.

## Adding a Logo

To add a logo to the documentation site, you will need to do the following:

1.  Create a `logo.png` file and place it in the `docs/assets` directory.
2.  Uncomment the `avatar` option in the `docs/_config.yml` file and set the value to `/assets/logo.png`.

```yaml
# docs/_config.yml

# ...

# the avatar on sidebar, support local or CORS resources
avatar: "/assets/logo.png"

# ...
```
