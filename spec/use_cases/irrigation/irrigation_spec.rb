require_relative 'spec_helper'

describe 'an app for controlling a thermostat' do

  let(:repo) { RDF::Repository.new }
  let(:ontology) { Ontology.new(repo) }

  before { load_app_definition(ontology) }

  let(:app) { ontology.applications.first }

  describe 'there are no actions because we don\'t have the devices' do
    subject { app.actions.any? }
    it { is_expected.to eq false }
  end

  describe 'starting the devices' do
    before { load_irrigator_definition(ontology) }
    before { load_ph_sensor_definition(ontology) }
    before { load_moisture_sensor_definition(ontology) }

    before { ontology.refresh }

    describe 'there are no actions yet' do
      subject { app.actions.any? }
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

        describe 'there should be a start action now' do
          let(:start_action) { app.action_with_description('Start irrigation') }
          let(:execution) { start_action.execution }

          subject { start_action }
          it { is_expected.not_to eq nil }

          describe 'the command' do
            subject { execution.command }
            it { is_expected.to eq 'start' }
          end

          describe 'argument descriptions' do
            subject { execution.arguments.map { |a| a.description } }
            it { is_expected.to eq [ 'Irrigator', 'Moisture Sensor', 'Ph Sensor' ] }
          end

          describe 'effect' do
            let(:state_change) { start_action.effect }
            let(:changed_ontology) { state_change.apply }

            it 'the irrigator should be controlled by the app' do
              r = changed_ontology.query([ nil, LV.controlledBy, app.query.node ])
              expect(r.size).to eq 1
            end
          end
        end
      end
    end
  end
end
