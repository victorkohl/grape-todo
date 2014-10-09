require 'rubygems'
require 'bundler'
require 'active_support/all'
require File.expand_path('../application', __FILE__)

Bundler.require(:default, Todo.env)
Mongoid.load!(File.expand_path('../mongoid.yml', __FILE__), Todo.env)

[:models, :helpers, :api].each do |directory|
  Dir[File.dirname(__FILE__) + "/../#{directory}/**/*.rb"].each { |file| require file }
end
