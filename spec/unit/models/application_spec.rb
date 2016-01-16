require_relative '../spec_helper'

def create_repo
  RDF::Repository.new do |r|
    r << [:a, RDF.type, LV.Application]
    r << [:a, RDF::Vocab::FOAF.name, 'Some App']
    r << [:a, LV.description, 'Description of the app.']

    r << [:a, LV.hasDeploymentPlan, :deployment_plan1]
    r << [:a, LV.hasDeploymentPlan, :deployment_plan2]
    r << [:deployment_plan1, LV.description, 'This needs to be so and so.']
    r << [:deployment_plan2, LV.description, 'This needs to be so and so.']
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

  context '#deployment_plans' do
    subject { app.deployment_plans.size }
    it { is_expected.to eq 2 }

    describe 'should not have doubles' do
      before do
        repo << [ :a, LV.hasDeploymentPlan, :deployment_plan2 ]
      end

      it { is_expected.to eq 2 }
    end
  end
end
