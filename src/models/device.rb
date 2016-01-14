class Device
  attr_reader :query

  def initialize(node, repository)
    @query = NodeQuery.new(node, repository)
  end

  def manufacturer_name
    query.value(LV.manufacturer_name)
  end

  def description
    query.value(LV.description)
  end

  def location
    node = query.value(LV.located_at)
    return nil if node.nil?

    Location.new(node, query.repository)
  end

  def node
    query.node
  end
end
