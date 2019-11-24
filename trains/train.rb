require_relative 'modules/company_name.rb'
require_relative 'modules/instance_counter.rb'

class Train
  include CompanyName
  include InstanceCounter

  EMPTY_NAME_ERROR = 'Train name can nott be empty!'
  NUMBER_FORMAT_ERROR = 'Invalid train number format!( XXX-XX )'
  ACCELERATE_ERROR = 'Accelerate must be integer!'
  TYPE_MISMATCH_ERROR = 'Wrong Carrriage type!'
  SPEED_ERROR = 'You must stop to add/delete carriage!'
  CARRIAGES_SIZE_ERROR = 'No cars to delete!'
  NOT_EMPTY_CAR_ERROR = 'This car is not empty!'
  ROUTE_ERROR = 'No route specified!'
  NEXT_STATION_ERROR = 'There is no next station!'
  PREVIOUS_STATION_ERROR = 'There is no previous station!'
  NUMBER_FORMAT = /^[a-zа-я\d]{3}-?[a-zа-я\d]{2}$/i

  end
  attr_reader :number, :carriages, :route
  attr_accessor :speed

  @@trains = {}

  def self.find(number)
    @@trains[number]
  end

  def initialize(number, company_name)
    @speed = 0
    @number = number
    @carriages = []
    @route = route
    validate!
    register_instance
    @@trains[number] = self
  end

  def speed_control(value)
    @speed = @speed + value
    @speed = 0 if @speed < 0
  end

  def stop
    @speed = 0
  end

  def add_carriage(carriage)
    add_carriage_validate!(carriage)
    carriages << carriage
  end

  def delete_carriage
    delete_carriage_validate!(carriage)
    carriages.delete(carriages.last)
  end

  def add_route=(route)
    @route = route
    @route.start.add_train(self)
  end

  def current_station
    current_route.find { |station| station.trains.include?(self) }
  end

  def next_station
    route.stations[index_for(current_station) + 1]
  end

  def previous_station
    if current_station > 0
      route.stations[index_for(current_station) - 1]
    end
  end

  def go_next_station
    return unless @route
    return unless next_station
    current_station.send_train(self)
    index_for(previous_station) + 1
    current_station.add_train(self)
  end

  def go_previous_station
    return unless @route
    return unless previous_station
    current_station.send_train(self)
    index_for(next_station) - 1
    current_station.add_train(self)
  end

  def current_route
    @route.stations
  end

  def index_for(station)
    current_route.index(station)
  end

  def each_carriage(&block)
    carriages.each { |car| yield(car) }
  end
#valid

  def valid?
    validate!
    true
  rescue
    false
  end

  private

  def validate!
    if company_name.nil? || company_name.length.zero?
      raise EMPTY_NAME_ERROR
    end
    if number.nil? || number !~ NUMBER_FORMAT
      raise NUMBER_FORMAT_ERROR
    end
  end

  def accelerate_validate!(value)
    unless value.is_a? Integer
      raise ACCELERATE_ERROR
    end
  end

  def add_carriage_validate!(carriage)
    unless carriage.is_a?(Carriage) && attachable_carriage?(carriage)
      raise TYPE_MISMATCH_ERROR
    end
    raise SPEED_ERROR unless speed.zero?
  end

  def delete_carriage_validate!(carriage)
    raise SPEED_ERROR unless speed.zero?
    case carriage
    when CargoCarriage
      if carriage.reserved_capacity.positive?
        raise NOT_EMPTY_CAR_ERROR
      end
    when PassengerCarriage
      if carriage.reserved_seats.positive?
        raise NOT_EMPTY_CAR_ERROR
      end
    end
    raise NOT_EMPTYCAR_ERROR if carriage.reserved_capacity.positive?
    raise CARRIAGES_SIZE_ERROR unless carriages.size.positive?
  end

  def go_next_station_validate!
    raise ROUTE_ERROR if route.nil?
    if route.stations[@current_station_index + 1].nil?
      raise NEXT_STATION_ERROR
    end
  end

  def go_previous_station_validate!
    raise ROUTE_ERROR if route.nil?
    unless @current_station_index.positive?
      raise PREVIOUS_STATION_ERROR
    end
  end
end
