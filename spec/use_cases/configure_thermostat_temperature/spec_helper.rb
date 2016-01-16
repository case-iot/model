require_relative '../spec_helper'

def load_thermostat_definition(repo)
  read_def(repo, File.dirname(__FILE__) + '/thermostat.n3')
end

def load_thermostat_app_definition(ontology)
  n3 = File.read(File.dirname(__FILE__) + '/thermostat_control_app.n3')
  ontology.load_and_process_n3 n3
end
