class PassengerCarriage < Carriage
  attr_reader :type
  def initialize(number)
    @number = number
    @type = :passenger
  end
end
