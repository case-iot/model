module RepositoryProxy
  def <<(statement)
    repository << statement
  end

  def delete(statement)
    repository.delete(statement)
  end

  def query(q)
    repository.query(q)
  end

  def first_object(pattern)
    repository.first_object(pattern)
  end
end
