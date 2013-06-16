require 'sinatra'
require "sinatra/json"
require 'multi_json'
require './exp_parser'
require 'haml'

get '/smorg' do
  haml :character, :format => :html5
end

get '/smorg_exp.json' do
  parser = ExpLogParser.new("Smorg")
  json parser.data
end