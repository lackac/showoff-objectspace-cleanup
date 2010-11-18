require ::File.dirname(__FILE__) + '/config/boot.rb'

require '../object_counter'
use ObjectCounter

run Padrino.application
