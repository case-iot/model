class Capability
  attr_reader :query

  def initialize(node, repository)
    @query = NodeQuery.new(node, repository)
  end

  def description
    query.value(LV.description)
  end

  def actuators
    query.values(LV.actuator).map do |node|
      Device.new node, query.repository
    end
  end

  def sensors
    query.values(LV.sensor).map do |node|
      Device.new node, query.repository
    end
  end
end
