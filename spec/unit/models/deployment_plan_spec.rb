require_relative '../spec_helper'

describe DeploymentPlan do
  let(:repo) { RDF::Repository.new }
  let(:ontology) { Ontology.new(repo) }
  let(:deployment_plan) { DeploymentPlan.new(:a, repo) }

  before do
    repo << [:deployment_plan, LV.description, 'Install the app']
  end

  context '#description' do
    subject { deployment_plan.description }
    it { is_expected.to eq('Install the app') }
  end

  context '#arguments' do
    before do
      arguments = RDF::List[ 'arg1', 'arg2' ]
      repo << arguments
      repo << [ :deployment_plan, LV.arguments, arguments ]
    end
    let(:arguments) { deployment_plan.arguments }

    subject { arguments.to_a }
    it { is_expected.to eq [ 'arg1', 'arg2' ] }
  end
end
