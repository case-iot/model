require_relative 'spec_helper'

describe 'an app for irrigating fields based on the crops' do

  let(:repo) { RDF::Repository.new }
  let(:ontology) { Ontology.new(repo) }
  let(:loader) { IrrigationBasedOnCropTypeLoader.new(ontology) }

  before { loader.app }

  let(:app) { ontology.applications.first }

  describe 'there are no deployment plans because we don\'t have the devices' do
    subject { app.deployment_plans.any? }
    it { is_expected.to eq false }
  end

  describe 'starting the devices' do
    before { loader.irrigator }
    before { loader.ph_sensor }
    before { loader.moisture_sensor }

    before { ontology.refresh }

    let(:moisture_sensor) { ontology.device_with_description('Moisture Sensor') }
    let(:ph_sensor) { ontology.device_with_description('Ph Sensor') }
    let(:irrigator) { ontology.device_with_description('Irrigator') }

    describe 'there are no deployment plans yet' do
      subject { app.deployment_plans.any? }
      it { is_expected.to eq false }
    end

    describe 'the question' do
      let(:question) { app.questions.first }
      let(:answer) { question.answer! }

      describe 'description' do
        subject { question.text }
        it { is_expected.to eq 'What is the crop type?' }
      end

      describe 'options' do
        subject { answer.options }
        it { is_expected.to eq [ 'Cereals', 'Soya', 'Wine' ] }
      end

      describe 'answering' do
        before { answer.selected = 'Wine' }
        before { ontology.refresh }

        describe 'there should be a deployment plan now' do
          let(:deployment_plan) { app.deployment_plan_with_description('Using irrigator, moisture and Ph sensor') }

          subject { deployment_plan }
          it { is_expected.not_to eq nil }

          describe 'argument descriptions' do
            subject { deployment_plan.arguments }
            it do
              is_expected.to eq [
                'Wine',
                irrigator.node,
                moisture_sensor.node,
                ph_sensor.node
              ]
            end
          end

          describe 'capabilities' do
            let(:capability) { deployment_plan.capabilities.first }

            subject { capability }
            it { is_expected.not_to eq nil }

            describe 'description' do
              subject { capability.description }
              it { is_expected.to eq 'Field irrigation' }
            end

            describe 'actuators' do
              subject { capability.actuators.map { |a| a.description } }
              it { is_expected.to eq [ 'Irrigator' ] }
            end

            describe 'sensors' do
              subject { capability.sensors.map { |s| s.description } }
              it { is_expected.to eq [
                'Moisture Sensor',
                'Ph Sensor'
              ] }
            end
          end
        end
      end
    end
  end
end
