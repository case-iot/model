require_relative '../spec_helper'

class DynamicChoiceOfMovementSensorsLoader
  def initialize(ontology)
    @ontology = ontology
  end

  def app
    n3 = File.read(File.dirname(__FILE__) + '/app.n3')
    @ontology.load_and_process_n3 n3
  end

  def movement_sensor_in(location)
    node = NodeBuilder.create({
      RDF.type => [
        LV.Device,
        LV.Sensor
      ],
      LV.senses => LV.movement,
      LV.locatedAt => [ LV.locationName => location ]
    }, @ontology)

    Device.new(node, @ontology)
  end
end
