require_relative '../spec_helper'

def read_def(repo, path)
  RDF::N3::Reader.open(path) do |reader|
    reader.each_statement do |statement|
      # ruby-rdf created very long names for variables with the
      # full path to the folder, which Eye couldn't reason about
      # so here, the name is shortened to remove the path
      if statement.subject.variable?
        full_name = statement.subject.to_s
        var_name = full_name.split('#').last.to_sym
        statement.subject = RDF::Query::Variable.new(var_name)
      end
      repo << statement
    end
  end
  repo
end
