#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
before do
  @title = 'bot ahokai'
end

def auth?
  false
end

get '/' do
  haml :index
end

get '/login' do
end

get '/logout' do
end
