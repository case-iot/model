module Answer
  def self.create(reply_type, node, repository)
    case reply_type
    when :location
      Location.new(node, repository)
    when :temperature
      Temperature.new(node, repository)
    when :select
      Selection.new(node, repository)
    else
      nil
    end
  end

  def reply_type
    question.reply_type
  end

  def question
    node = query.value(QV.answers)
    return nil if node.nil?

    Question.new(node, query.repository)
  end
end
