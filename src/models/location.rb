class Location
  attr_reader :query

  include Answer

  def initialize(node, repository)
    @query = NodeQuery.new(node, repository)
  end

  def name
    query.value(LV.locationName)
  end

  def name=(value)
    query.set_value(LV.locationName, value)
  end
end
