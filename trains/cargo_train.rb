class CargoTrain < Train
  attr_reader :type
  def type
    @type = :cargo
  end
  def add_carriage(carriage)
    super if carriage.type == :cargo
  end
end

