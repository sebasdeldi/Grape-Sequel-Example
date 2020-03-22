# frozen_string_literal: true

require 'rake/spectask'

Rake::TestTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.libs << 'lib'
  t.libs << 'spec'
end

task default: :spec
