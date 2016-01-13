require_relative '../services/question_references'

class Action
  attr_reader :query

  include QuestionReferences

  def initialize(node, repository)
    @query = NodeQuery.new(node, repository)
  end

  def description
    query.value(LV.description)
  end

  def requirements
    list = RDF::List.new(query.value(LV.requirement), query.repository)
    list.map { |node| Requirement.new(node, query.repository) }
  end

  def failed_requirements
    requirements.select {|r| not r.satisfied? }
  end

  def compatible?
    not failed_requirements.any?
  end

  def questions
    q = []
    q << question if has_question?

    with_question = requirements.select { |r| r.has_question? }
    q + with_question.map { |r| r.question }
  end

  def open_questions
    questions.select { |q| not q.has_answer? }
  end

  def execution
    ActionExecution.new(query.value(LV.executes), query.repository)
  end

  def effect
    StateChange.new(query.value(LV.effect), query.repository)
  end
end
