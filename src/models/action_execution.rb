class ActionExecution
  attr_reader :query

  def initialize(node, repository)
    @query = NodeQuery.new(node, repository)
  end

  def command
    query.value(LV.command)
  end

  def arguments
    list = RDF::List.new(query.value(LV.argument), query.repository)
    list.map { |node| Device.new(node, query.repository) }
  end

  def execute
    raise 'Not implemented'
  end
end
