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

  def unsatisfied_installation_steps
    installation_steps.select {|s| not s.satisfied? }
  end

  def compatible?
    not failed_requirements.any? and
      not unsatisfied_installation_steps.any?
  end

  def questions
    with_question = requirements.select { |r| r.has_question? }
    with_question.map { |r| r.question }
  end

  def open_questions
    questions.select { |q| not q.has_answer? }
  end

  def description
    query.value(LV.description)
  end

  def installation_steps
    list = RDF::List.new(query.value(LV.installation), query.repository)
    list.map do |node|
      InstallationStep.new(node, query.repository)
    end
  end

  def install
    installation_steps.each { |step| step.execute }
  end
end
