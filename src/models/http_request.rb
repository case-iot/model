require 'rest-client'

class HttpRequest
  attr_reader :query

  def initialize(node, repository)
    @query = NodeQuery.new(node, repository)
  end

  def uri
    query.value(HttpVocabulary.request_uri)
  end

  def body
    query.value(HttpVocabulary.body)
  end

  def method_name
    query.value(HttpVocabulary.method_name)
  end

  def execute
    raise "Unsupported method #{method_name}" unless method_name == 'POST'
    RestClient.post(uri.to_s, body.to_s)
    true
  end
end
