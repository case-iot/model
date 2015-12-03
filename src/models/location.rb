class Location
  attr_reader :query

  def initialize(node, repository)
    @query = NodeQuery.new(node, repository)
  end

  def name
    query.value(LV.location_name)
  end

  def name=(value)
    query.set_value(LV.location_name, value)
  end
end
