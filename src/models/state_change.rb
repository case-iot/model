class StateChange
  attr_reader :query

  def initialize(node, repository)
    @query = NodeQuery.new(node, repository)
  end

  def apply
    new_repo = query.repository.clone
    new_repo.load_and_process_n3(state_rules)
    new_repo
  end

  private

  def state_rules
    File.read(File.dirname(__FILE__) + '/../descriptions/states.n3')
  end
end
