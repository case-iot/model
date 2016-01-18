class Application
  attr_reader :query

  def initialize(node, repository)
    @query = NodeQuery.new(node, repository)
  end

  def name
    if query.value_exists?(RDF::Vocab::FOAF.name)
      query.value(RDF::Vocab::FOAF.name)
    else
      query.value(LV.name)
    end
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

  def question_with_text(text)
    questions.find { |q| q.text == text }
  end

  def requirements
    list = repo.query([nil, RDF.type, QV.Requirement]).map { |s| s.subject }
    list.map { |node| Requirement.new(node, repo) }
  end

  def requirement_with_description(description)
    requirements.find { |r| r.description == description }
  end

  def deployment_plans
    query.values(LV.hasDeploymentPlan).map do |node|
      DeploymentPlan.new(node, repo)
    end
  end

  def deployment_plan_with_description(description)
    deployment_plans.find { |a| a.description == description }
  end

  private

  def repo
    query.repository
  end
end
