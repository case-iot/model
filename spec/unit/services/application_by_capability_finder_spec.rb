require_relative '../spec_helper'

describe ApplicationByCapabilityFinder do
  let(:repo) { RDF::Repository.new }
  let(:ontology) { Ontology.new repo }
  let(:finder) { ApplicationByCapabilityFinder.new ontology }

  before do
    repo << [ :app1, RDF.type, LV.Application ]
    repo << [ :app1, LV.description, 'Some app' ]
    repo << [ :app1, LV.hasDeploymentPlan, :dp1 ]
    repo << [ :dp1, LV.capability, :capability1 ]
    repo << [ :capability1, RDF.type, LV.Irrigation ]
    repo << [ :capability1, LV.actuator, :irrigator1 ]
    repo << [ :irrigator1, LV.description, 'The irrigator' ]

    repo << [ :app2, RDF.type, LV.Application ]
    repo << [ :app2, LV.description, 'Some other app' ]
    repo << [ :app2, LV.hasDeploymentPlan, :dp2 ]
    repo << [ :dp2, LV.capability, :capability2 ]
    repo << [ :capability2, RDF.type, LV.SmartHome ]
    repo << [ :capability2, LV.actuator, LV.light ]
    repo << [ LV.light, LV.description, 'Light' ]
  end

  context '#find' do
    describe 'by the capability type' do
      let(:applications) do
        finder.find({
          RDF.type => LV.Irrigation
        })
      end

      context '#size' do
        subject { applications.size }
        it { is_expected.to eq 1 }
      end

      context '#description' do
        subject { applications.first.description }
        it { is_expected.to eq 'Some app' }
      end
    end
  end

  context '#find_by_actuator' do
    describe 'by actuator node' do
      let(:applications) do
        finder.find_by_actuator(LV.light)
      end

      context '#size' do
        subject { applications.size }
        it { is_expected.to eq 1 }
      end

      context '#description' do
        subject { applications.first.description }
        it { is_expected.to eq 'Some other app' }
      end
    end

    describe 'by the actuator type' do
      let(:applications) do
        finder.find_by_actuator({
          LV.description => 'Light'
        })
      end

      context '#size' do
        subject { applications.size }
        it { is_expected.to eq 1 }
      end

      context '#description' do
        subject { applications.first.description }
        it { is_expected.to eq 'Some other app' }
      end
    end
  end
end
