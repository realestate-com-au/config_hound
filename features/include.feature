Feature: inclusion

Scenario: File includes another

  Given "config.yml" contains
    """
    foo: 42
    _include: included.yml
    """

  And "included.yml" contains
    """
    foo: 1
    bar: 2
    """

  Then loading "config.yml" should return
    """
    {
      "foo" => 42,
      "bar" => 2
    }
    """

Scenario: Multiple levels of inclusion

  Given "config.yml" contains
    """
    from_config: C
    _include: a.yml
    """

  And "a.yml" contains
    """
    from_a: A
    _include: b.yml
    """

  And "b.yml" contains
    """
    from_b: B
    """

  Then loading "config.yml" should return
    """
    {
      "from_config" => "C",
      "from_a" => "A",
      "from_b" => "B",
    }
    """

Scenario: Relative inclusion

  Given "config.yml" contains
    """
    from_config: C
    _include: subdir/a.yml
    """

  And "subdir/a.yml" contains
    """
    from_a: A
    _include: b.yml
    """

  And "subdir/b.yml" contains
    """
    from_b: B
    """

  Then loading "config.yml" should return
    """
    {
      "from_config" => "C",
      "from_a" => "A",
      "from_b" => "B",
    }
    """
