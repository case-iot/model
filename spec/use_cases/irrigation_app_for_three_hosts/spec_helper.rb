require_relative '../spec_helper'

class IrrigationFor3HostsLoader
  def initialize(ontology)
    @ontology = ontology
  end

  def app
    n3 = File.read(File.dirname(__FILE__) + '/irrigation_app.n3')
    @ontology.load_and_process_n3 n3
  end

  def create_ecosystem_host(i = 0)
    node = NodeBuilder.create({
      RDF.type => [
        LV.Device,
        LV.Irrigator,
        LV.EcosystemHost
      ],
      LV.manufacturerName => 'Mrkvicka',
      LV.description => i.to_s
    }, @ontology)

    Device.new(node, @ontology)
  end
end
