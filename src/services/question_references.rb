module QuestionReferences
  def has_question?
    query.value_exists?(LV.requires_answering)
  end

  def has_condition?
    query.value_exists?(LV.condition)
  end

  def question
    node = query.value(LV.requires_answering)
    return nil if node.nil?
    Question.new(node, query.repository)
  end

  def question_answered?
    question.has_answer?
  end
end
