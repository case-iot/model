class Selection
  attr_reader :query

  include Answer

  def initialize(node, repository)
    @query = NodeQuery.new(node, repository)
  end

  def options
    RDF::List.new(question.query.value(QV.options), query.repository)
  end

  def selected
    query.value(LV.selected)
  end

  def selected=(value)
    query.set_value(LV.selected, value)
  end
end
