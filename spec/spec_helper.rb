require 'rubygems'
require 'bundler/setup'
require 'gitdo'

module Helpers
end

RSpec.configure do |config|
  config.include Helpers
end