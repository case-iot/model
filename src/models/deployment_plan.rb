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

  def host
    nil unless query.value_exists?(LV.host)
    EcosystemHost.new(query.value(LV.host), query.repository)
  end

  def arguments
    node = query.value(LV.arguments)
    arg_query = NodeQuery.new(node, query.repository)

    if arg_query.value_exists?(RDFV.first)
      RDF::List.new(node, query.repository)
    else
      arg_query.predicates_and_objects
    end
  end

  def deployment_plans
    query.values(LV.hasDeploymentPlan).map do |node|
      DeploymentPlan.new(node, query.repository)
    end
  end

  def capabilities
    list = RDF::List.new(query.value(LV.capabilities), query.repository)
    list.map do |node|
      Capability.new(node, query.repository)
    end
  end
end
