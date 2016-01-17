class RDFVocabulary
  def self.method_missing(name, *arguments, &block)
    uri_for(name)
  end

  def self.uri_for(name)
    RDF::URI("http://www.w3.org/1999/02/22-rdf-syntax-ns##{name}")
  end
end

RDFV = RDFVocabulary
