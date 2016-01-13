require_relative '../services/question_references'

class Requirement
  attr_reader :query

  include QuestionReferences

  def initialize(node, repository)
    @query = NodeQuery.new(node, repository)
  end

  def description
    query.value(LV.description)
  end

  def satisfied?
    query.value(LV.satisfied) == true
  end

  def condition_satisfied?
    graph_satisfied? query.value(LV.condition)
  end

  private

  def graph_satisfied?(graph_name)
    reasoner = Reasoner.new(query.repository)
    reasoner.check_condition(graph_name)
  end
end
