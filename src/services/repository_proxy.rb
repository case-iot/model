module RepositoryProxy
  def graph(name)
    graph_name = if name.is_a? Symbol; "_:#{name.to_s}"; else; name.to_s; end
    g = RDF::Graph.new
    repository.statements.each do |statement|
      next if statement.graph_name.nil?
      next unless statement.graph_name.to_s.include? graph_name

      g << [ statement.subject, statement.predicate, statement.object ]
    end
    g
  end

  def facts_only
    RDF::Graph.new do |g|
      repository.statements.each do |statement|
        g << statement if statement.graph_name.nil?
      end
    end
  end

  # proxy everything to the repository
  def method_missing(method, *args, &block)
    repository.send(method, *args, &block)
  end
end
