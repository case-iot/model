class HttpVocabulary
  def self.method_missing(name, *arguments, &block)
    uri_for(name)
  end

  def self.method_name
    uri_for('methodName')
  end

  def self.request_uri
    uri_for('requestURI')
  end

  def self.uri_for(name)
    RDF::URI("http://www.w3.org/2011/http##{name}")
  end
end
