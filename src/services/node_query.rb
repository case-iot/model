class NodeQuery
  attr_reader :node, :repository

  def initialize(node, repository)
    @node = node
    @repository = repository
  end

  def value(predicate)
    values(predicate).first
  end

  def values(predicate)
    results = repository.query([ node, predicate, nil ])
    results.map {|s| s.object }
  end

  def value_exists?(predicate)
    values(predicate).any?
  end

  def set_value(predicate, object)
    delete_value(predicate)
    @repository << [ node, predicate, object ]
  end

  private

  def delete_value(predicate)
    # makes sure not to delete any values in subgraphs
    repository.query([ node, predicate, nil ]).select do |s|
      s.graph_name.nil?
    end.each do |s|
      repository.delete(s)
    end
  end
end
