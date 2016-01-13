class ActionStep
  attr_reader :query

  def initialize(node, repository)
    @query = NodeQuery.new(node, repository)
  end

  def description
    query.value(LV.description)
  end

  def satisfied?
    reasoner = Reasoner.new(repository)
    reasoner.check_condition(given_graph_name)
  end

  def requests
    return nil unless satisfied?

    repo = implied_repository
    statements = repo.query([ nil, HttpVocabulary.method_name, nil ])

    statements.map { |statement| HttpRequest.new(statement.subject, repo) }
  end

  def execute
    requests.each { |request| request.execute }
  end

  private

  def implied_repository
    reasoner = Reasoner.new(repository)
    reasoner.imply(given_graph_name, execute_graph_name)
  end

  def given_graph_name
    query.value(LV.given)
  end

  def execute_graph_name
    query.value(LV.execute)
  end

  def repository
    query.repository
  end
end
