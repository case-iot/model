class EyeSerializer
  def self.serialize_implication(facts, precondition, postcondition)
    pre = serialize_graph(precondition)
    post = serialize_graph(postcondition)
    "#{facts.dump(:ntriples)}{#{pre}} => {#{post}}."
  end

  def self.serialize_graph(graph)
    statements = []
    graph.each_statement do |statement|
      statements << RDF::Statement.new({
        subject: statement.subject,
        predicate: statement.predicate,
        object: statement.object
      }).to_s
    end
    statements.join
  end
end
