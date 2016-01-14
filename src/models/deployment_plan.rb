require_relative '../services/question_references'

class DeploymentPlan
  attr_reader :query

  include QuestionReferences

  def initialize(node, repository)
    @query = NodeQuery.new(node, repository)
  end

  def description
    query.value(LV.description)
  end

  def arguments
    RDF::List.new(query.value(LV.arguments), query.repository)
  end

  def capabilities
    list = RDF::List.new(query.value(LV.capabilities), query.repository)
    list.map do |node|
      Capability.new(node, query.repository)
    end
  end
end
