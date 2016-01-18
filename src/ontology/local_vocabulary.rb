require 'rdf'

class LocalVocabulary
  def self.method_missing(name, *arguments, &block)
    uri_for(name)
  end

  def self.name
    uri_for('name')
  end

  def self.question_type
    uri_for('question')
  end

  def self.answer_type
    uri_for('answer')
  end

  def self.uri_for(name)
    RDF::URI("http://matus.tomlein.org/case/#{name}")
  end
end

LV = LocalVocabulary
QV = LocalVocabulary
