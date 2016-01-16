require_relative 'spec_helper'

describe 'an app that turns on the light when there is movement' do
  let(:repo) { RDF::Repository.new }
  let(:ontology) { Ontology.new(repo) }

  before do # load the app
    load_light_control_app(repo)
  end

  let(:app) { ontology.applications.first }

  describe 'there are no deployment plans yet' do
    subject { app.deployment_plans.any? }
    it { is_expected.to eq false }
  end

  describe 'answering the question' do
    let(:question) { app.questions.first }

    describe 'the question' do
      subject { question.text }
      it { is_expected.to eq 'Where do you want to control the lights?' }
    end

    it 'is unanswered' do
      expect(question.has_answer?).to eq false
    end

    describe 'answering the question with location Bathroom' do
      let(:answer) { question.answer! }
      before { answer.name = 'Bathroom' }

      describe 'finds no deployment plans because there are no devices in the bathroom' do
        subject { app.deployment_plans.any? }
        it { is_expected.to eq false }
      end
    end

    describe 'answering the question with location Kitchen' do
      let(:answer) { question.answer! }
      before { answer.name = 'Kitchen' }

      let(:light_requirement) { app.requirement_with_description 'Light needed' }
      let(:sensor_requirement) { app.requirement_with_description 'Movement sensor needed' }

      describe 'light requirement not satisfied yet' do
        subject { light_requirement.satisfied? }
        it { is_expected.to eq false }
      end

      describe 'sensor requirement not satisfied yet' do
        subject { light_requirement.satisfied? }
        it { is_expected.to eq false }
      end

      describe 'light requirement satisfied' do
        before { load_kitchen_light(repo) }
        before { ontology.refresh }
        subject { light_requirement.satisfied? }
        it { is_expected.to eq true }
      end

      describe 'sensor requirement satisfied' do
        before { load_kitchen_movement_sensor(repo) }
        before { ontology.refresh }
        subject { sensor_requirement.satisfied? }
        it { is_expected.to eq true }
      end

      describe 'both devices loaded' do
        before do # start the devices
          load_kitchen_light(repo)
          load_kitchen_movement_sensor(repo)
        end
        before { ontology.refresh }

        let(:deployment_plan) { app.deployment_plan_with_description('Start monitoring the sensor') }

        it 'finds the deployment plan' do
          expect(deployment_plan).not_to eq nil
        end

        describe 'the arguments of the plan' do
          let(:subscribe_url) { 'http://140.129.123.12/subscribe' }
          let(:notify_url) { 'http://140.129.133.21/turn_on' }

          subject { deployment_plan.arguments }
          it { is_expected.to eq [ subscribe_url, notify_url ] }
        end
      end
    end
  end
end
