class Requirement
  attr_reader :query

  def initialize(node, repository)
    @query = NodeQuery.new(node, repository)
  end

  def description
    query.value(LV.description)
  end

  def satisfied?
    if has_question? and not question_answered?
      return false
    end

    if has_condition? and not condition_satisfied?
      return false
    end

    true
  end

  def has_question?
    query.value_exists?(LV.requires_answering)
  end

  def has_condition?
    query.value_exists?(LV.condition)
  end

  def question_answered?
    question.has_answer?
  end

  def condition_satisfied?
    graph_satisfied? query.value(LV.condition)
  end

  def question
    node = query.value(LV.requires_answering)
    return nil if node.nil?
    Question.new(node, query.repository)
  end

  private

  def graph_satisfied?(graph_name)
    reasoner = Reasoner.new(query.repository)
    reasoner.check_condition(graph_name)
  end
end
