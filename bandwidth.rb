require "rubygems"
require "bundler/setup"

require 'faraday'
require 'yaml'
require 'awesome_print'
require 'nokogiri'

class Bandwidth
  class GetError < StandardError; end
  class ParseError < StandardError; end
  class NoDataError < StandardError; end

  attr_reader :username
  attr_reader :password
  attr_reader :endpoint

  attr_reader :client

  def initialize(username, password, host)
    @username = username
    @password = password
    @endpoint = "http://#{ host }/ttgraph.cgi"

    initialize_client
  end

  def initialize_client
    @client = Faraday.new( :url => @endpoint )
    @client.basic_auth( @username, @password )
  end

  def get(date)
    uri = "?#{ date.strftime "%m-%Y" }"
    r = @client.get( uri )

    status = r.status
    body = r.body

    if status != 200
      raise GetError.new("Expected 200, but got #{ status }")
    end

    parse_body(body)
  end

  def parse_body(body)
    html = Nokogiri::HTML(body)

    summary = html.css('#label').text.strip

    unless m = summary.match(/Incoming:\s*(\d+)\s.*?Outgoing:\s*(\d+)\s/i)
      raise ParseError.new("Error finding bandwdith info!")
    end

    result = { :incoming => m[1].to_i, :outgoing => m[2].to_i }

    raise NoDataError.new("Got no data!") if (result[:incoming] == result[:outgoing]) == 0
    puts result

    result
  end
end

config_file = File.join( File.dirname(__FILE__), 'config.yml' )
config = YAML.load_file( config_file )

b = Bandwidth.new( config['username'], config['password'], config['host'] )

usage = {}
d = Date.today

begin
  puts "Fetching for #{ d.strftime "%m-%Y" }"
  r = b.get(d)
  usage[d.strftime("%m-%Y")] = r unless r[:incoming] == 0
  d = d.prev_month
rescue
  puts "Done."
end while r[:incoming] != 0

ap usage

