require_relative '../spec_helper'

def create_repo
  RDF::Repository.new do |r|
    # APPS
    r << [:a, RDF.type, LV.Application]
    r << [:a, RDF::Vocab::FOAF.name, 'Some App']
    r << [:a, LV.description, 'Description of the app.']
    # REQUIREMENTS
    list = RDF::List[:requirement1, :requirement2]
    r << list
    r << [:a, LV.requirement, list.subject]
    r << [:requirement1, LV.description, 'This needs to be so and so.']
    r << [:requirement2, LV.description, 'This needs to be like this.']
    # CONDITIONS
    r << [:requirement1, LV.condition, :req1_condition]
    r << [:requirement2, LV.condition, :req2_condition]
    device = RDF::Query::Variable.new(:device1)
    r << [device, RDF.type, LV.car, :req1_condition]
    r << [device, RDF.type, LV.vehicle, :req2_condition]
  end
end

describe Application do
  let(:repo) { create_repo }
  let(:ontology) { Ontology.new(repo) }
  let(:app) { Application.new(:a, repo) }

  context '#name' do
    subject { app.name }
    it { is_expected.to eq('Some App') }
  end

  context '#description' do
    subject { app.description }
    it { is_expected.to eq('Description of the app.') }
  end

  context '#requirements' do
    let(:requirements) { app.requirements }

    describe 'number of requirements' do
      subject { requirements.size }
      it { is_expected.to eq 2 }
    end

    describe 'first requirement' do
      subject { requirements.first.description }
      it { is_expected.to eq 'This needs to be so and so.' }
    end

    describe 'second requirement' do
      subject { requirements.last.description }
      it { is_expected.to eq 'This needs to be like this.' }
    end
  end

  context '#compatible?' do
    subject { app.compatible? }
    it { is_expected.to eq false }

    describe 'satisfy first requirement' do
      before { repo << [ :device, RDF.type, LV.car ] }
      it { is_expected.to eq false }

      describe 'satisfy second requirement' do
        before { repo << [ :device, RDF.type, LV.vehicle ] }
        it { is_expected.to eq true }
      end
    end
  end
end
