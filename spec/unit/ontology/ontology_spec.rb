require_relative '../spec_helper'

repo = RDF::Repository.new do |r|
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

describe Ontology do
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
end
