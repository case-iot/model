class Application
  attr_reader :query

  def initialize(node, repository)
    @query = NodeQuery.new(node, repository)
  end

  def name
    query.value(RDF::Vocab::FOAF.name)
  end

  def requirements
    list = RDF::List.new(query.value(LV.requirement), query.repository)
    list.map do |node|
      Requirement.new(node, query.repository)
    end
  end

  def failed_requirements
    requirements.select {|r| not r.satisfied? }
  end

  def requirements_satisfied?
    not failed_requirements.any?
  end

  def open_questions
    with_question = requirements.select { |r| r.has_question? }
    questions = with_question.map { |r| r.question }
    questions.select { |q| not q.has_answer? }
  end

  def description
    query.value(LV.description)
  end

  def compatible?
    AppCompatibilityReasoner.new(self).compatible?
  end
end
