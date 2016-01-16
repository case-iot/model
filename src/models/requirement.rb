require_relative '../services/question_references'

class Requirement
  attr_reader :query

  def initialize(node, repository)
    @query = NodeQuery.new(node, repository)
  end

  def description
    query.value(LV.description)
  end

  def satisfied?
    query.value(LV.satisfied) == true
  end
end
