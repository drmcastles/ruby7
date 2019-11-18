class CargoCarriage < Carriage
  attr_reader :type
  def initialize(number)
    @number = number
    @type = :cargo
  end
end
