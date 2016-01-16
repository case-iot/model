require_relative '../spec_helper'

describe Ontology do
  let(:repo) { RDF::Repository.new }
  let(:ontology) { Ontology.new(repo) }
  let(:requirement) { Requirement.new(:req, repo) }

  before do
    repo << [ :req, LV.description, 'This needs to be so and so.' ]
  end

  context '#description' do
    subject { requirement.description }
    it { is_expected.to eq('This needs to be so and so.') }
  end

  context '#satisfied?' do
    describe 'satisfied requirement' do
      before { repo << [ :req, LV.satisfied, true ] }
      subject { requirement.satisfied? }
      it { is_expected.to eq true }
    end

    describe 'not satisfied requirement' do
      subject { requirement.satisfied? }
      it { is_expected.to eq false }
    end
  end
end
