require_relative '../spec_helper'

class LightControlBasedOnMovementDetectionLoader < UseCaseLoader
  def initialize(ontology)
    @ontology = ontology
  end

  def kitchen_movement_sensor
    read_def(@ontology, File.dirname(__FILE__) + '/kitchen_movement_sensor.n3')
  end

  def kitchen_light
    read_def(@ontology, File.dirname(__FILE__) + '/kitchen_light.n3')
  end

  def app
    n3 = File.read(File.dirname(__FILE__) + '/light_control_app.n3')
    @ontology.load_and_process_n3 n3
  end
end
