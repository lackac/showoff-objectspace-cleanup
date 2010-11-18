require 'rubygems'
require 'sinatra'
require './sinatra-app'

set :env,  :production
disable :run

require '../object_counter'
use ObjectCounter

run SinatraApp
