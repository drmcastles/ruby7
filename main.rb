require_relative 'interface.rb'
require_relative 'station.rb'
require_relative 'route.rb'
require_relative 'trains/train.rb'
require_relative 'trains/cargo_train.rb'
require_relative 'trains/passenger_train.rb'
require_relative 'carriages/passenger.rb'
require_relative 'carriages/carriage.rb'
require_relative 'carriages/cargo.rb'
require 'securerandom'

main = Main.new
main.execute

