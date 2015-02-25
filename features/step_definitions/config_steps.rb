require "yaml"

Given /^"([^\"]*)" contains$/ do |path, content|
  unless path =~ %r(^\w+:/)
    path = File.expand_path(path)
  end
  @inputs[path] = content
end

Then /^loading "([^\"]*)" should return$/ do |path, config|
  expected_result = eval(config)
  result = @loader.load(path)
  expect(result).to eq expected_result
end
