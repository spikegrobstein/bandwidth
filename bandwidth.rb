require "rubygems"
require "bundler/setup"

require 'faraday'
require 'yaml'
require 'awesome_print'
require 'nokogiri'

config_file = File.join( File.dirname(__FILE__), 'config.yml' )
config = YAML.load_file( config_file )

endpoint = "http://#{ config['host'] }/ttgraph.cgi"

c = Faraday.new( :url => endpoint )
c.basic_auth(config['username'], config['password'])

r = c.get('?3-2013')

status = r.status
body = r.body

html = Nokogiri::HTML(body)

summary = html.css('#label').text.strip

ap summary
