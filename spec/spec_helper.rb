require 'case_model'
require 'webmock/rspec'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

class UseCaseLoader
  def read_def(repo, path)
    RDF::N3::Reader.open(path) do |reader|
      reader.each_statement do |statement|
        # ruby-rdf created very long names for variables with the
        # full path to the folder, which Eye couldn't reason about
        # so here, the name is shortened to remove the path
        if statement.subject.variable?
          statement.subject = process_var_name(statement.subject)
        end
        if statement.predicate.variable?
          statement.predicate = process_var_name(statement.predicate)
        end
        if statement.object.variable?
          statement.object = process_var_name(statement.object)
        end
        repo << statement
      end
    end
    repo
  end

  def process_var_name(object)
    full_name = object.to_s
    var_name = full_name.split('#').last.to_sym
    RDF::Query::Variable.new(var_name)
  end
end
