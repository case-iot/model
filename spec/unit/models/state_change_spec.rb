require_relative '../spec_helper'

describe StateChange do
  let(:repo) { RDF::Repository.new }
  let(:ontology) { Ontology.new(repo) }
  let(:state_change) { StateChange.new(:state_change, repo) }

  before do
    repo << [ :state, RDF.type, StateVocabulary.State ]
    repo << [ :state_change, RDF.type, StateVocabulary.StateChange ]
    repo << [ :state_change, StateVocabulary.added, :added ]
    repo << [ :state_change, StateVocabulary.removed, :removed ]
    repo << [ :state_change, StateVocabulary.parent, :state ]

    repo << [ :thermostat, :state, :active, :added ]
  end

  context '#achieves_goal' do
    describe 'successful goal' do
      let(:goal) do
        RDF::Graph.new { |r| r << [ :thermostat, :state, :active ] }
      end

      subject { state_change.achieves_goal? goal }
      it { is_expected.to eq true }
    end

    describe 'unsuccesful goal' do
      let(:goal) do
        RDF::Graph.new { |r| r << [ :thermostat, :state, :inactive ] }
      end

      subject { state_change.achieves_goal? goal }
      it { is_expected.to eq false }
    end
  end
end
