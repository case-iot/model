require_relative 'spec_helper'

describe 'an app for irrigating fields using 3 actuators where the user chooses the master' do

  let(:repo) { RDF::Repository.new }
  let(:ontology) { Ontology.new(repo) }
  let(:loader) { IrrigationFor3HostsWithUserQuestionLoader.new(ontology) }

  before { loader.app }

  let(:app) { ontology.applications.first }
  let(:deployment_plans) { app.deployment_plans }

  describe 'there are no deployment plans because we don\'t have the devices' do
    subject { deployment_plans.any? }
    it { is_expected.to eq false }
  end

  let(:question) { app.question_with_text('Which device do you want to use as master?') }
  let(:answer) { question.answer! }

  describe 'the question is not present because the requirements are not satisfied' do
    subject { question.nil? }
    it { is_expected.to eq true }
  end

  describe 'satisfying the requirements by adding three hosts' do
    let!(:host1) { loader.create_ecosystem_host(1) }
    let!(:host2) { loader.create_ecosystem_host(2) }
    let!(:host3) { loader.create_ecosystem_host(3) }
    before { ontology.refresh }

    describe 'the question is there now' do
      subject { question.nil? }
      it { is_expected.to eq false }
    end

    describe 'options of the question' do
      subject { answer.options.sort }
      it do
        is_expected.to eq [ host1.node, host2.node, host3.node ].sort
      end
    end

    describe 'there are still no deployment plans' do
      subject { deployment_plans.size }
      it { is_expected.to eq 0 }
    end

    describe 'choosing the master' do
      before { answer.selected = host2.node }
      before { ontology.refresh }

      describe 'there is one deployment plan' do
        subject { deployment_plans.size }
        it { is_expected.to eq 1 }
      end

      let(:deployment_plan) { deployment_plans.first }

      describe 'there are three sub-plans' do
        subject { deployment_plan.deployment_plans.size }
        it { is_expected.to eq 3 }
      end

      describe 'master deployment plan' do
        let(:master_plan) { deployment_plan.deployment_plans.find {|p| p.host.node == host2.node } }

        describe 'host' do
          subject { master_plan.host.node }
          it { is_expected.to eq host2.node }
        end

        describe 'arguments' do
          subject { master_plan.arguments[LV.slave] }
          it { is_expected.to include host1.node }
          it { is_expected.to include host3.node }
          it { is_expected.not_to include host2.node }
        end
      end

      describe 'slave deployment plans' do
        let(:slave_plans) { deployment_plan.deployment_plans.select {|p| p.host.node != host2.node } }

        describe 'hosts' do
          let(:hosts) { slave_plans.map {|p| p.host.node } }

          subject { hosts }
          it { is_expected.to include host1.node }
          it { is_expected.to include host3.node }
          it { is_expected.not_to include host2.node }
        end

        describe 'arguments' do
          let(:arguments) { slave_plans.map {|p| p.arguments }.uniq }

          subject { arguments }
          it { is_expected.to eq [ { LV.master => host2.node } ] }
        end
      end
    end
  end
end
