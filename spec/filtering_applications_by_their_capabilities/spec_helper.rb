require_relative '../spec_helper'

class FilteringApplicationsByTheirCapabilitiesLoader
  def initialize(ontology)
    @ontology = ontology
  end

  def apps
    n3 = File.read(File.dirname(__FILE__) + '/apps.n3')
    @ontology.load_and_process_n3 n3
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

  def ph_sensor
    node = NodeBuilder.create({
      RDF.type => [
        LV.Device,
        LV.Sensor
      ],
      LV.sensorType => LV.phSensor
    }, @ontology)

    Device.new(node, @ontology)
  end

  def sprinkler
    node = NodeBuilder.create({
      RDF.type => [
        LV.Device,
        LV.Irrigator,
        LV.EcosystemHost
      ],
      LV.irrigatorType => LV.sprinkler
    }, @ontology)

    Device.new(node, @ontology)
  end

  def central_pivot_irrigator(i = 0)
    node = NodeBuilder.create({
      RDF.type => [
        LV.Device,
        LV.Irrigator,
        LV.EcosystemHost
      ],
      LV.irrigatorType => LV.centralPivot
    }, @ontology)

    Device.new(node, @ontology)
  end

  def kitchen_light
    node = NodeBuilder.create({
      RDF.type => [ LV.Device, LV.Light ],
      LV.locatedAt => { LV.locationName => "Kitchen" }
    }, @ontology)

    Device.new(node, @ontology)
  end

  def kitchen_movement_sensor
    node = NodeBuilder.create({
      RDF.type => [ LV.Device, LV.Sensor ],
      LV.senses => LV.movement,
      LV.locatedAt => { LV.locationName => 'Kitchen' }
    }, @ontology)

    Device.new(node, @ontology)
  end

  def bedroom_light
    node = NodeBuilder.create({
      RDF.type => [ LV.Device, LV.Light ],
      LV.locatedAt => { LV.locationName => 'Bedroom' }
    }, @ontology)

    Device.new(node, @ontology)
  end

  def bedroom_smoke_detector
    node = NodeBuilder.create({
      RDF.type => [ LV.Sensor, LV.Device ],
      LV.senses => LV.smoke,
      LV.locatedAt => { LV.locationName => 'Bedroom' }
    }, @ontology)

    Device.new(node, @ontology)
  end
end
