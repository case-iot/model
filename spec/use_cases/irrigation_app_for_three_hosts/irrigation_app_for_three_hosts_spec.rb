require_relative 'spec_helper'

describe 'an app for irrigating fields using 3 actuators' do

  let(:repo) { RDF::Repository.new }
  let(:ontology) { Ontology.new(repo) }

  before { load_3_host_irrigator_app_definition(ontology) }

  let(:app) { ontology.applications.first }
  let(:deployment_plans) { app.deployment_plans }

  let(:requirement_for_one) { app.requirement_with_description 'Host 1 required' }
  let(:requirement_for_two) { app.requirement_with_description 'Host 2 required' }
  let(:requirement_for_three) { app.requirement_with_description 'Host 3 required' }
  let(:requirements_satisfied) { [
    requirement_for_one.satisfied?,
    requirement_for_two.satisfied?,
    requirement_for_three.satisfied?
  ] }

  describe 'there are no deployment plans because we don\'t have the devices' do
    subject { deployment_plans.any? }
    it { is_expected.to eq false }
  end

  describe 'no requirements satisfied' do
    subject { requirements_satisfied }
    it { is_expected.to eq [ false, false, false ] }
  end

  describe 'adding one host' do
    let!(:host1) { create_irrigator_that_is_a_ecosystem_host(ontology, 1) }
    before { ontology.refresh }

    describe 'one out of three requirements is satisfied' do
      subject { requirements_satisfied }
      it { is_expected.to eq [ true, false, false ] }
    end

    describe 'adding the second host' do
      let!(:host2) { create_irrigator_that_is_a_ecosystem_host(ontology, 2) }
    before { ontology.refresh }

      describe 'two out of three requirements is satisfied' do
        subject { requirements_satisfied }
        it { is_expected.to eq [ true, true, false ] }
      end

      describe 'adding the third host' do
        let!(:host3) { create_irrigator_that_is_a_ecosystem_host(ontology, 3) }
    before { ontology.refresh }

        describe 'all requirements is satisfied' do
          subject { requirements_satisfied }
          it { is_expected.to eq [ true, true, true ] }
        end

        describe 'there are three deployment plan' do
          subject { deployment_plans.size }
          it { is_expected.to eq 3 }
        end

        let(:dp1) { deployment_plans[0] }

        it 'should have sub-plans for all the hosts' do
          expect(
            dp1.deployment_plans.map {|p| p.host.description }.sort
          ).to eq [ '1', '2', '3' ]
        end

        describe 'arguments of the deployment plans' do
          subject do
            deployment_plans.map do |p|
              p.deployment_plans.map {|a| a.arguments }
            end.flatten
          end

          it do
            is_expected.to include({
              LV.master => host1.node
            })
          end

          it do
            is_expected.to include({
              LV.slave => [ host1.node,
                            host2.node ]
            })
          end

          it do
            is_expected.not_to include({
              LV.slave => host1.node,
              LV.slave => host1.node
            })
          end
        end
      end
    end
  end

  describe 'adding 10 hosts' do
    before do
      10.times do
        create_irrigator_that_is_a_ecosystem_host(ontology)
      end
      ontology.refresh
    end

    describe 'there are a lot of deployment plan' do
      subject { deployment_plans.size }
      it { is_expected.to eq 360 }
    end
  end
end
