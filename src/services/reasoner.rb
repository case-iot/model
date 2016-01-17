require 'rdf/n3'
require 'tempfile'

class Reasoner
  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  # implication doesn't work well when a blank node is used in the
  # condition, e.g.:
  # {?device1 <http://...#type> _:vehicle .} => {...}
  # will always result in the postcondition, because of _:vehicle
  def imply(precondition, postcondition)
    eye_input = EyeSerializer.serialize_implication(
      repository.facts_only,
      repository.graph(precondition),
      repository.graph(postcondition)
    )

    eye_output = run_eye eye_input
    parse_eye_output eye_output
  end

  # makes sure that the graph with name condition is valid
  # to do that, it creates a temporary graph (:helper_graph) and tries to imply
  # condition => helper_graph
  # it creates a new temp_reasoner object so as not to modify the current repository
  # with the helper_graph
  def check_condition(condition)
    temp_repository = @repository.clone
    temp_repository << [ LV.condition, LV.was, LV.true, :helper_graph ]

    temp_reasoner = Reasoner.new temp_repository
    result = temp_reasoner.imply(condition, :helper_graph)

    result.query([ LV.condition, LV.was, LV.true ]).any?
  end

  def load_and_process_n3(n3_input)
    input = [
      n3_input,
      EyeSerializer.serialize_graph(repository.facts_only)
    ].join

    eye_output = run_eye input
    parse_eye_output eye_output, @repository
    @repository
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

  def parse_eye_output(output, repo = nil)
    output = remove_incompatible_prefix_from_eye_output output
    repo = RDF::Repository.new if repo.nil?
    reader = RDF::Reader.for(:n3).new(output)
    reader.each_statement { |statement| repo << statement }
    repo
  end

  def remove_incompatible_prefix_from_eye_output(output)
    output.gsub(/PREFIX .+\n/) do |match|
      match.sub('PREFIX ', '@prefix ') + '.'
    end
  end
end
