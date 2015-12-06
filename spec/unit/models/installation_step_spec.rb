require_relative '../spec_helper'

describe InstallationStep do
  let(:repo) { RDF::Repository.new }
  let(:ontology) { Ontology.new(repo) }
  let(:installation_step) { InstallationStep.new(:install, repo) }

  before do
    repo << [ :install, LV.description, 'This will install something' ]
    repo << [ :install, LV.given, :given_block ]
    repo << [ :install, LV.execute, :execute_block ]

    thermostat_var = RDF::Query::Variable.new(:thermostat)
    repo << [ thermostat_var, RDF.type, LV.thermostat, :given_block ]
  end

  context '#description' do
    subject { installation_step.description }
    it { is_expected.to eq 'This will install something' }
  end

  context '#satisfied?' do
    subject { installation_step.satisfied? }
    it { is_expected.to eq false }

    describe 'adding the device' do
      before { repo << [ :thermostat, RDF.type, LV.thermostat ] }

      it { is_expected.to eq true }
    end
  end

  context '#requests' do
    before do
      repo << [ :r1, HttpVocabulary.method_name, 'GET', :execute_block ]
      repo << [ :r2, HttpVocabulary.method_name, 'POST', :execute_block ]
    end

    describe 'without satisfied the given block' do
      subject { installation_step.requests }
      it { is_expected.to eq nil }
    end

    describe 'with the given block satisfied' do
      before { repo << [ :thermostat, RDF.type, LV.thermostat ] }

      describe 'size' do
        subject { installation_step.requests.size }
        it { is_expected.to eq 2 }
      end

      describe 'first request' do
        subject { installation_step.requests.first.method_name }
        it { is_expected.to eq 'GET' }
      end

      describe 'second request' do
        subject { installation_step.requests.last.method_name }
        it { is_expected.to eq 'POST' }
      end
    end
  end
end
