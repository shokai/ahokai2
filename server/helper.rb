require 'rubygems'
require 'bundler/setup'
require 'rack'
require 'sinatra/reloader'
require 'bson'
gem 'mongoid','>=2.0.0'
require 'mongoid'
require 'yaml'
require 'json'
require 'oauth'
require 'twitter'
#require File.dirname(__FILE__)+'/models/tweet'
#require File.dirname(__FILE__)+'/models/user'

begin
  @@conf = YAML::load open(File.dirname(__FILE__)+'/config.yaml').read
  p @@conf
rescue => e
  STDERR.puts 'config.yaml load error!'
  STDERR.puts e
end

Mongoid.configure{|conf|
  conf.master = Mongo::Connection.new(@@conf['mongo_server'], @@conf['mongo_port']).db(@@conf['mongo_dbname'])
}

if production?
  use Rack::Session::Cookie,
  :key => 'rack.session',
  :domain => @@conf['session_domain'],
  :path => '/',
  :expire_after => 60*60*24*14, # 2 weeks
  :secret => @@conf['session_secret']
end

def consumer
  OAuth::Consumer.new(@@conf['twitter_key'], @@conf['twitter_secret'],
                      :site => "http://twitter.com")
end

def app_root
  "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}#{env['SCRIPT_NAME']}"
end

