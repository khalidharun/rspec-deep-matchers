require "deep/matchers/deep_eql.rb"
require "deep/matchers/deep_include.rb"
module RSpec::Matchers
  include Deep::Matchers
end
