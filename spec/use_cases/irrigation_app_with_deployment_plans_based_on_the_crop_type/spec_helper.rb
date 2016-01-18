require_relative '../spec_helper'

class IrrigationAppWithDeploymentBasedOnTheCropTypeLoader < UseCaseLoader
  def initialize(ontology)
    @ontology = ontology
  end

  def wine_irrigator(i = 0)
    node = NodeBuilder.create({
      RDF.type => [
        LV.Device,
        LV.Irrigator,
        LV.EcosystemHost
      ],
      LV.manufacturerName => 'Mrkvicka',
      LV.irrigatorType => LV.sprinkler,
      LV.description => i.to_s
    }, @ontology)

    Device.new(node, @ontology)
  end

  def cereal_irrigator(i = 0)
    node = NodeBuilder.create({
      RDF.type => [
        LV.Device,
        LV.Irrigator,
        LV.EcosystemHost
      ],
      LV.manufacturerName => 'Mrkvicka',
      LV.irrigatorType => LV.centralPivot,
      LV.description => i.to_s
    }, @ontology)

    Device.new(node, @ontology)
  end

  def moisture_sensor
    node = NodeBuilder.create({
      RDF.type => [
        LV.Device,
        LV.Sensor
      ],
      LV.sensorType => LV.moistureSensor
    }, @ontology)

    Device.new(node, @ontology)
  end

  def app
    n3 = File.read(File.dirname(__FILE__) + '/irrigation_app.n3')
    @ontology.load_and_process_n3 n3
  end
end
