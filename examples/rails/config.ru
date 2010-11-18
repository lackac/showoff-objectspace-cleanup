# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

require '../object_counter'
use ObjectCounter

run RailsApp::Application
