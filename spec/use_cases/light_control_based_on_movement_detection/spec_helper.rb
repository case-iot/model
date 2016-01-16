require_relative '../spec_helper'

def load_kitchen_movement_sensor(repo)
  read_def(repo, File.dirname(__FILE__) + '/kitchen_movement_sensor.n3')
end

def load_kitchen_light(repo)
  read_def(repo, File.dirname(__FILE__) + '/kitchen_light.n3')
end

def load_light_control_app(repo)
  n3 = File.read(File.dirname(__FILE__) + '/light_control_app.n3')
  ontology.load_and_process_n3 n3
end
