require_relative '../spec_helper'

def load_3_host_irrigator_app_definition(ontology)
  n3 = File.read(File.dirname(__FILE__) + '/irrigation_app.n3')
  ontology.load_and_process_n3 n3
end

def create_irrigator_that_is_a_ecosystem_host(ontology, i = 0)
  node = NodeBuilder.create({
    RDF.type => [
      LV.Device,
      LV.Irrigator,
      LV.EcosystemHost
    ],
    LV.manufacturer_name => 'Mrkvicka',
    LV.description => i.to_s
  }, ontology)

  Device.new(node, repo)
end
