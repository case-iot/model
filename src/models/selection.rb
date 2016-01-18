class Selection
  attr_reader :query

  include Answer

  def initialize(node, repository)
    @query = NodeQuery.new(node, repository)
  end

  def options
    if question.query.value_exists?(QV.options)
      RDF::List.new(question.query.value(QV.options), query.repository)
    elsif question.query.value_exists?(QV.option)
      question.query.values(QV.option)
    else
      nil
    end
  end

  def selected
    query.value(LV.selected)
  end

  def selected=(value)
    # in case it is an array, store all the answers
    if value.is_a? Array
      value.each { |v| query.set_value(LV.selected, v, false) }
    else
      query.set_value(LV.selected, value)
    end
  end
end
