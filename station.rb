require_relative 'modules/instance_counter.rb'

class Station
  include InstanceCounter

  EMPTY_NAME_ERROR = 'Station name can not be empty!'
  TRAINS_ERROR = 'There are no trains at this station!'
  DUPLICATE_ERROR = 'This station already exist!'

  attr_reader :name, :trains


  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = []
    register_instance
    validate!
    @@stations << self
    register_instance
  end


  def add_train(train)
    trains_on_station_validate!
    trains << train unless trains.include?(train)
  end

  def send_train(train)
    trains_on_station_validate!
    trains.delete(train) if trains.include?(train)
  end

  def cargo_trains
    trains_list(CargoTrain)
  end

  def passenger_trains
    trains_list(PassengerTrain)
  end


  def trains_list(target)
    trains_on_station_validate!
    trains.select{ |train| return train.number if train.class == target}
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  private

  def validate!
    if name.nil? || name.length.zero?
      raise EMPTY_NAME_ERROR
    end
    if @@stations.any? { |station| station.name == name }
      raise DUPLICATE_ERROR
    end
  end

  def trains_on_station_validate!
    raise TRAINS_ERROR if trains.empty?
  end
end
