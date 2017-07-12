# ConfigHound

ConfigHound makes it easy to load configuration data that is
spread between multiple files.

## Usage

    # load YAML
    config = ConfigHound.load("config.yml")

    # load JSON
    config = ConfigHound.load("config.json")

    # load TOML
    config = ConfigHound.load("config.toml")

## Inclusion

ConfigHound let's you include defaults from other files.
Just list the file paths (or URLs) under the key `_include`,

For example, in `config.yml`:

```
_include:
  - defaults.yml
pool:
  size: 10
log:
  file: "app.log"
```

then in `defaults.yml`

```
log:
  level: INFO
pool:
  size: 1
```

Values in the original config file override those from included files.
Multiple levels of inclusion are possible.

If the placeholder "`_include`" doesn't suit, you can specify
another, e.g.

    config = ConfigHound.load("config.yml", :include_key => "defaults")

## Contributing

It's on GitHub; you know the drill.

## See also

ConfigHound works well with:

* [ConfigMapper](https://github.com/mdub/config_mapper)
