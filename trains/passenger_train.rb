class PassengerTrain < Train
  attr_reader :type
  def type
    @type = :passenger
  end

  def add_carriage(carriage)
    super if carriage.type == :passenger
  end
end
