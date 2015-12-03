require 'rdf/n3'
require 'tempfile'

class Reasoner
  def initialize(repository)
    @repository = repository
  end

  def check_condition(condition)
    @repository << [ LV.condition, LV.was, LV.true, :helper_graph ]
    result = imply(condition, :helper_graph)
    result.query([ LV.condition, LV.was, LV.true ]).size == 1
  end

  def imply(precondition, postcondition)
    eye_input = EyeSerializer.serialize_implication(
      facts_only,
      graph(precondition),
      graph(postcondition)
    )

    eye_output = run_eye eye_input
    parse_eye_output eye_output
  end

  private

  def run_eye(input)
    data = Tempfile.new('data')
    data.write(input)
    data.close
    output = `eye --nope --pass #{data.path} 2> /dev/null`
    data.unlink

    output
  end

  def parse_eye_output(output)
    repo = RDF::Repository.new
    reader = RDF::Reader.for(:n3).new(output)
    reader.each_statement do |statement|
      repo << statement
    end
    repo
  end

  def graph(name)
    RDF::Graph.new do |g|
      @repository.statements.each do |statement|
        next if statement.graph_name.nil?
        next unless statement.graph_name.to_s.include?(
          if name.is_a? Symbol
            '_:' + name.to_s
          else
            name.to_s
          end
        )

        g << [ statement.subject,
               statement.predicate,
               statement.object ]
      end
    end
  end

  def facts_only
    RDF::Graph.new do |g|
      @repository.statements.each do |statement|
        g << statement if statement.graph_name.nil?
      end
    end
  end
end
