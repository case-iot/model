class QuestionReplyType
  def self.to_sym(query)
    case query.value(QV.reply_type)
    when QV.location
      :location
    when QV.temperature
      :temperature
    when QV.select
      :select
    else
      nil
    end
  end
end
