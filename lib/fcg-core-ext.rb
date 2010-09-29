require "rubygems"
require 'yajl/json_gem'
require 'andand'
require 'hashie'
include Hashie::HashExtensions

$LOAD_PATH.unshift(File.dirname(__FILE__))

Dir[
  File.expand_path("../fcg-core-ext/*.rb", __FILE__)
].each do |file|
  require file
end