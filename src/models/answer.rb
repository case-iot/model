class Answer
  attr_reader :query

  def initialize(node, repository)
    @query = NodeQuery.new(node, repository)
  end

  def reply_type
    question.reply_type
  end

  def question
    node = query.value(QV.answers)
    return nil if node.nil?

    Question.new(node, query.repository)
  end

  def value
    case reply_type
    when :location
      Location.new(query.node, query.repository)
    when :temperature
      Temperature.new(query.node, query.repository)
    else
      nil
    end
  end
end
