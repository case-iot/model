require_relative '../spec_helper'

describe Location do
  let(:repo) do
    RDF::Repository.new do |r|
      # ANSWER
      r << [:location, RDF.type, QV.answer_type]
      r << [:location, RDF.type, QV.location]
      r << [:location, LV.location_name, 'Living Room']
    end
  end

  let(:ontology) { Ontology.new(repo) }
  let(:location) { Location.new(:location, repo) }

  context '#name' do
    subject { location.name }
    it { is_expected.to eq('Living Room') }
  end

  context '#name=' do
    before :each do
      location.name = 'Kitchen'
    end

    subject { location.name }
    it { is_expected.to eq('Kitchen') }

    describe 'new instances should have the changed value' do
      let(:new_answer) { Location.new(:location, repo) }

      subject { new_answer.name }
      it { is_expected.to eq('Kitchen') }
    end
  end
end
