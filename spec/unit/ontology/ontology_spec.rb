require_relative '../spec_helper'

describe Ontology do
  let(:repo) do
    RDF::Repository.new do |r|
      # APPS
      r << [:app1, RDF.type, LV.Application]
      r << [:app1, RDF::Vocab::FOAF.name, 'App 1']
      r << [:app2, RDF.type, LV.Application]
      r << [:app2, RDF::Vocab::FOAF.name, 'App 2']

      # DEVICES
      r << [:dev1, RDF.type, LV.Device]
      r << [:dev1, LV.manufacturer_name, 'Grundfos']
      r << [:dev2, RDF.type, LV.Device]
      r << [:dev2, LV.manufacturer_name, 'Danfoss']
    end
  end
  let(:ontology) { Ontology.new(repo) }

  context '#applications' do
    let(:apps) { ontology.applications }

    it 'finds 2 applications' do
      expect(apps.size).to eq(2)
    end

    it 'gives the right names' do
      expect(apps.first.name).to eq('App 1')
      expect(apps.last.name).to eq('App 2')
    end
  end

  context '#devices' do
    let(:devices) { ontology.devices }

    it 'finds 2 devices' do
      expect(devices.size).to eq(2)
    end

    it 'gives the right names' do
      expect(devices.first.manufacturer_name).to eq('Grundfos')
      expect(devices.last.manufacturer_name).to eq('Danfoss')
    end
  end

  context '#refresh' do
    let(:n3_input) { '@prefix c: <http://matus.tomlein.org/case/>.
                     { ?a c:knows ?b. } => { ?b c:knows ?a. }.' }
    before { ontology.load_and_process_n3(n3_input) }

    it 'executes the rule after refresh' do
      any = lambda { ontology.query([ LV.marry, LV.knows, LV.john ]).any? }

      ontology << [ LV.john, LV.knows, LV.marry ]
      expect(any.call).to eq false

      ontology.refresh
      expect(any.call).to eq true
    end
  end
end
