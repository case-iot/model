require 'rdf'
require 'rdf/vocab'

class Ontology
  def initialize(repository)
    @repository = repository
  end

  def applications
    repo.query([nil, RDF.type, LV.Application]).map do |statement|
      Application.new(statement.subject, repo)
    end
  end

  def devices
    repo.query([nil, RDF.type, LV.Device]).map do |statement|
      Device.new(statement.subject, repo)
    end
  end

  private

  def repo; @repository; end
end
