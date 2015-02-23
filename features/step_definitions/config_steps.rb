require "configuration_loader"
require "yaml"

Given /^"([^\"]*)" contains$/ do |path, content|
  @inputs[path] = content
end

Then /^loading "([^\"]*)" should return$/ do |path, yaml_config|
  expected_result = YAML.load(yaml_config)
  result = ConfigurationLoader.load(path)
  expect(result).to eq expected_result
end
