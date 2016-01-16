require_relative '../spec_helper'

describe StateChange do
  let(:repo) { RDF::Repository.new }
  let(:ontology) { Ontology.new(repo) }
  let(:state_change) { StateChange.new(:state_change, ontology) }

  before do
    repo << [ :state, RDF.type, StateVocabulary.State ]
    repo << [ :state_change, RDF.type, StateVocabulary.StateChange ]
    repo << [ :state_change, StateVocabulary.added, :added ]
    repo << [ :state_change, StateVocabulary.removed, :removed ]
    repo << [ :state_change, StateVocabulary.parent, :state ]

    repo << [ :app, RDF.type, LV.Application, :added ]
    repo << [ :app, LV.description, 'A new app', :added ]
  end

  describe 'before applying the state change' do
    let(:app) { ontology.applications.first }

    subject { app.nil? }
    pending { is_expected.to eq true }
  end

  context '#apply' do
    let(:new_ontology) { state_change.apply }
    let(:app) { new_ontology.applications.first }

    subject { app.description }
    it { is_expected.to eq 'A new app' }
  end
end
