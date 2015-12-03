class QuestionReplyType
  def self.to_sym(query)
    case query.value(QV.reply_type)
    when QV.location
      :location
    when QV.temperature
      :temperature
    else
      nil
    end
  end
end
