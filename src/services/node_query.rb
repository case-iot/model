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

  def set_value(predicate, object, replace = true)
    delete_value(predicate) if replace
    @repository << [ node, predicate, object ]
  end

  def predicates_and_objects
    values = {}
    repository.query([ node, nil, nil ]).each do |s|
      if values.has_key? s.predicate
        if values[s.predicate].is_a? Array
          values[s.predicate] << s.object
        else
          values[s.predicate] = [
            values[s.predicate], s.object
          ]
        end
      else
        values[s.predicate] = s.object
      end
    end
    values
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
