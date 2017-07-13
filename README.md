# ConfigHound

ConfigHound makes it easy to load configuration data.

## Usage

`ConfigHound.load` supports config in JSON, YAML or TOML formats, and returns raw Ruby data.

```ruby
config = ConfigHound.load("config.yml")   # or "config.{json,toml}"
```

## Remote config

As well as local files, you can load from any URI supported by `OpenURI`, e.g.

```ruby
# load over HTTP
ConfigHound.load("http://config-source/app-config.yml")

# load from S3
require "open-uri-s3"
config = ConfigHound.load("s3://config-bucket/app-config.json")
```

## Multiple sources of config

If you specify a list of config sources, ConfigHound will load them all, and deep-merge the data. Files specified earlier in the list take precedence.

```ruby
ConfigHound.load(["config.yml", "defaults.yml"])
```

You can include raw data (Hashes) in the list, too, which is handy if you have defaults or overrides already in Ruby format.

```ruby
overrides = { ... }
ConfigHound.load([overrides, "config.yml"])
```

## Inclusion

You can also "include" other file (or URIs) from _within_ a config file.
Just list the paths under the key `_include`.

For example, in `config.yml`:

```yaml
pool:
  size: 10
log:
  file: "app.log"
_include:
  - defaults.yml
```

then in `defaults.yml`

```yaml
log:
  level: INFO
pool:
  size: 1
```

Values in the original config file take precedence over those from included files.
Multiple levels of inclusion are possible.

If the placeholder "`_include`" doesn't suit, you can specify
another, e.g.

```ruby
config = ConfigHound.load("config.yml", :include_key => "defaults")
```

## Expansion

ConfigHound will expand references of the form `<(X.Y.Z)>` in config values, which can help DRY up configuration, e.g.

```yaml
name: myapp
aws:
  region: us-west-1
log:
  stream: <(name)>-logs-<(aws.region)>
```

Reference expansion is performed _after_ all config is loaded and merged, so you can reference config specified in other files.

## Contributing

It's on GitHub; you know the drill.

## See also

ConfigHound works well with:

* [ConfigMapper](https://github.com/mdub/config_mapper)
