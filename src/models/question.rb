class Question
  attr_reader :query

  def initialize(node, repository)
    @query = NodeQuery.new(node, repository)
  end

  def text
    query.value(QV.text).to_s
  end

  def reply_type
    QuestionReplyType.to_sym(query)
  end

  def has_answer?
    query.value_exists?(QV.has_answer)
  end

  # returns an existing one or nil if there is no
  def answer
    node = query.value(QV.has_answer)
    return nil if node.nil?

    Answer.create(reply_type, node, query.repository)
  end

  # creates a new answer or returns an existing one
  def answer!
    answer || create_answer
  end

  private

  def repository; query.repository; end

  def create_answer
    node = generate_answer_node
    repository << [ node, RDF.type, QV.answer_type ]
    answer_query = NodeQuery.new(node, repository)
    answer_query.set_value(QV.answers, query.node)
    query.set_value(QV.has_answer, node)

    answer
  end

  def generate_answer_node
    question_uri_hash = query.node.to_s.hash.to_s
    ('answer' + question_uri_hash).to_sym
  end
end
