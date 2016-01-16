require_relative '../spec_helper'

def load_irrigator_definition(repo)
  read_def(repo, File.dirname(__FILE__) + '/irrigator.n3')
end

def load_ph_sensor_definition(ontology)
  read_def(repo, File.dirname(__FILE__) + '/ph_sensor.n3')
end

def load_moisture_sensor_definition(ontology)
  read_def(repo, File.dirname(__FILE__) + '/moisture_sensor.n3')
end

def load_app_definition(ontology)
  n3 = File.read(File.dirname(__FILE__) + '/irrigation_app.n3')
  ontology.load_and_process_n3 n3
end
