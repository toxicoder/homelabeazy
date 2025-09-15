# Homelabeazy Documentation

This directory contains the source code for the Homelabeazy documentation site. The site is built with [Jekyll](https://jekyllrb.com/) and uses the [Minimal Mistakes](https://github.com/mmistakes/minimal-mistakes) theme.

## Development

To run the site locally, you will need to have Ruby and Bundler installed. Then, you can run the following commands:

```bash
bundle install
bundle exec jekyll serve
```

This will start a local web server at `http://localhost:4000`.

## Adding a Logo

To add a logo to the documentation site, you will need to do the following:

1.  Create a `logo.png` file and place it in the `docs/assets/images` directory.
2.  Uncomment the `avatar` option in the `docs/_config.yml` file.
