require_relative 'modules/instance_counter.rb'

class Route
  include InstanceCounter

TYPE_MISMATCH_ERROR = "Route elements must be \"Station\" type objects!"
DUPLICATE_ERROR = 'There is already such a station in the route!'
DELETE_ERROR = 'Can not delete start or last stations!'

attr_reader :stations, :start, :finish, :mid_stations
  def initialize(start, finish)
    @mid_stations = []
    @stations = []
    @start = start
    @finish = finish
    validate!
    register_instance
  end

  def add_station(station)
    mid_stations << station
  end

  def remove_station(station)
    mid_stations.delete(station)
  end

  def stations
    [start, mid_stations, finish].flatten
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  private

  def validate!
    unless stations.all? { |station| station.is_a?(Station) }
      raise TYPE_MISMATCH_ERROR
    end
    if stations.first == stations.last
      raise DUPLICATE_ERROR
    end
  end

  def delete_station_validate!(station)
    if [start, finish].include?(station)
      raise DELETE_ERROR
    end
  end

  def add_station_validate!(station)
    unless station.is_a?(Station)
      raise TYPE_MISMATCH_ERROR
    end
    if stations.include?(station)
      raise DUPLICATE_ERROR
    end
  end
end


