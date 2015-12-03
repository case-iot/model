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
    repository.delete([ node, predicate, nil ])
    @repository << [ node, predicate, object ]
  end
end
