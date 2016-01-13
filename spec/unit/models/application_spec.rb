require_relative '../spec_helper'

def create_repo
  RDF::Repository.new do |r|
    r << [:a, RDF.type, LV.Application]
    r << [:a, RDF::Vocab::FOAF.name, 'Some App']
    r << [:a, LV.description, 'Description of the app.']

    list = RDF::List[:action1, :action2]
    r << list
    r << [:a, LV.actions, list.subject]
    r << [:action1, LV.description, 'This needs to be so and so.']
    r << [:action2, LV.description, 'This needs to be so and so.']
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

  context '#actions' do
    subject { app.actions.size }
    it { is_expected.to eq 2 }

    describe 'non-referenced actions' do
      before { repo << [ :action3, RDF.type, LV.Action ] }

      it { is_expected.to eq 3 }
    end

    describe 'should not have doubles' do
      before { repo << [ :action2, RDF.type, LV.Action ] }

      it { is_expected.to eq 2 }
    end
  end
end
