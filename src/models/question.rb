class Question
  attr_reader :query

  def initialize(node, repository)
    @query = NodeQuery.new(node, repository)
  end

  def text
    query.value(QV.text)
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

    Answer.new(node, repository)
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

    create_location_device_link if reply_type == :location

    answer
  end

  def generate_answer_node
    question_uri_hash = query.node.to_s.hash.to_s
    ('answer' + question_uri_hash).to_sym
  end

  def create_location_device_link
    return unless query.value_exists?(QV.location_of)

    location_of.query.set_value(LV.located_at, answer.query.node)
  end

  def location_of
    device_node = query.value(QV.location_of)
    return nil if device_node.nil?
    Device.new(device_node, repository)
  end
end
