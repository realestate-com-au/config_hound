require "bundler/gem_tasks"

require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:cucumber) do |t|
  t.fork = true
end

task :default => :cucumber
