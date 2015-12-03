class MathVocabulary
  def self.method_missing(name, *arguments, &block)
    uri_for(name)
  end

  def self.less_than
    uri_for('lessThan')
  end

  def self.uri_for(name)
    RDF::URI("http://www.w3.org/2000/10/swap/math##{name}")
  end
end

MV = MathVocabulary
