Feature: basic config files

Scenario: YAML config

  Given "config.yml" contains
    """
    foo: 1
    bar: 2
    """

  Then loading "config.yml" should return
    """
    foo: 1
    bar: 2
    """

Scenario: JSON config

  Given "config.json" contains
    """
    {
      "foo": 1,
      "bar": 2
    }
    """

  Then loading "config.json" should return
    """
    foo: 1
    bar: 2
    """
