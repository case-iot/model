require_relative '../spec_helper'

class IrrigationBasedOnCropTypeLoader < UseCaseLoader
  def initialize(ontology)
    @ontology = ontology
  end

  def irrigator
    read_def(@ontology, File.dirname(__FILE__) + '/irrigator.n3')
  end

  def ph_sensor
    read_def(@ontology, File.dirname(__FILE__) + '/ph_sensor.n3')
  end

  def moisture_sensor
    read_def(@ontology, File.dirname(__FILE__) + '/moisture_sensor.n3')
  end

  def app
    n3 = File.read(File.dirname(__FILE__) + '/irrigation_app.n3')
    @ontology.load_and_process_n3 n3
  end
end
