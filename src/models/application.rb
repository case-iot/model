class Application
  attr_reader :query

  def initialize(node, repository)
    @query = NodeQuery.new(node, repository)
  end

  def name
    query.value(RDF::Vocab::FOAF.name)
  end

  def description
    query.value(LV.description)
  end

  def questions
    list = repo.query([nil, RDF.type, QV.Question]).map { |s| s.subject }
    list.map { |node| Question.new(node, repo) }
  end

  def open_questions
    questions.select { |q| not q.has_answer? }
  end

  def actions
    referenced = RDF::List.new(query.value(LV.actions), repo)
    other = repo.query([nil, RDF.type, LV.Action]).map { |s| s.subject }

    (referenced + other).uniq.map { |node| Action.new(node, repo) }
  end

  def action_with_description(description)
    actions.find { |a| a.description == description }
  end

  private

  def repo
    query.repository
  end
end
