class Temperature
  attr_reader :query

  include Answer

  def initialize(node, repository)
    @query = NodeQuery.new(node, repository)
  end

  def in_celsius
    query.value(LV.in_celsius)
  end

  def in_celsius=(value)
    query.set_value(LV.in_celsius, value)
  end
end
