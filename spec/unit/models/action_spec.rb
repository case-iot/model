require_relative '../spec_helper'

describe Action do
  let(:repo) { RDF::Repository.new }
  let(:ontology) { Ontology.new(repo) }
  let(:action) { Action.new(:a, repo) }

  before do
    repo << [:a, LV.description, 'Install the app']

    # REQUIREMENTS
    list = RDF::List[:requirement1, :requirement2]
    repo << list
    repo << [:a, LV.requirement, list.subject]
    repo << [:requirement1, LV.description, 'This needs to be so and so.']
    repo << [:requirement2, LV.description, 'This needs to be like this.']

    # CONDITIONS
    repo << [:requirement1, LV.condition, :req1_condition]
    repo << [:requirement2, LV.condition, :req2_condition]

    device = RDF::Query::Variable.new(:device1)
    repo << [device, RDF.type, LV.car, :req1_condition]
    repo << [device, RDF.type, LV.vehicle, :req2_condition]
  end

  context '#description' do
    subject { action.description }
    it { is_expected.to eq('Install the app') }
  end

  context '#requirements' do
    let(:requirements) { action.requirements }

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
    subject { action.compatible? }
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
