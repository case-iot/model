require_relative 'spec_helper'

describe 'an app for monitoring the movement in house' do

  let(:repo) { RDF::Repository.new }
  let(:ontology) { Ontology.new(repo) }
  let(:loader) { DynamicChoiceOfMovementSensorsLoader.new(ontology) }

  before { loader.app }

  let(:app) { ontology.applications.first }
  let(:deployment_plans) { app.deployment_plans }

  describe 'no deployment plans yet' do
    subject { deployment_plans.any? }
    it { is_expected.to eq false }
  end

  let(:questions) { app.questions }

  describe 'there are no questions yet as well' do
    subject { questions.any? }
    it { is_expected.to eq false }
  end

  let(:which_room_question) { app.question_with_text 'Which rooms do you want to monitor?' }
  let(:which_room_answer) { which_room_question.answer! }

  describe 'by adding a kitchen sensor, a question for the room appears' do
    before { loader.movement_sensor_in 'Kitchen' }
    before { ontology.refresh }

    subject { which_room_question.nil? }
    it { is_expected.to eq false }

    describe 'the options of the question' do
      subject { which_room_answer.options }
      it { is_expected.to eq [ 'Kitchen' ] }
    end
  end

  describe 'adding movement sensors in different rooms' do
    let!(:kitchen_sensor_1) { loader.movement_sensor_in 'Kitchen' }
    let!(:kitchen_sensor_2) { loader.movement_sensor_in 'Kitchen' }
    let!(:living_room_sensor) { loader.movement_sensor_in 'Living room' }
    let!(:bedroom_sensor) { loader.movement_sensor_in 'Bedroom' }
    before { ontology.refresh }

    describe 'the options of the question' do
      subject { which_room_answer.options.sort }
      it { is_expected.to eq [ 'Bedroom', 'Kitchen', 'Living room' ] }
    end

    let(:which_sensors_question) { app.question_with_text 'Which sensors do you want to use?' }
    let(:which_sensors_answer) { which_sensors_question.answer! }

    describe 'currently there is no question to choose the sensors to use' do
      subject { which_sensors_question.nil? }
      it { is_expected.to eq true }
    end

    describe 'choosing the kitchen' do
      before { which_room_answer.selected = 'Kitchen' }
      before { ontology.refresh }

      describe 'which sensors question appears' do
        subject { which_sensors_question.nil? }
        it { is_expected.to eq false }
      end

      describe 'the options to answer the question are the kitchen sensors' do
        subject { which_sensors_answer.options }
        it { is_expected.to include kitchen_sensor_1.node }
        it { is_expected.to include kitchen_sensor_2.node }

        it { expect(subject.size).to eq 2 }
      end
    end

    describe 'choosing the kitchen and bedroom' do
      before { which_room_answer.selected = [ 'Kitchen', 'Bedroom' ] }
      before { ontology.refresh }

      describe 'the options are both bedroom and kitchen sensors' do
        subject { which_sensors_answer.options }

        it { is_expected.to include kitchen_sensor_1.node }
        it { is_expected.to include kitchen_sensor_2.node }
        it { is_expected.to include bedroom_sensor.node }
        it { expect(subject.size).to eq 3 }
      end

      describe 'still no deployment plan' do
        subject { deployment_plans.size }
        it { is_expected.to eq 0 }
      end

      describe 'choose one bedroom and one kitchen sensor' do
        before { which_sensors_answer.selected = [ kitchen_sensor_1.node,
                                                   bedroom_sensor.node ] }

        before { ontology.refresh }

        describe 'deployment plan is created' do
          subject { deployment_plans.size }
          it { is_expected.to eq 1 }
        end

        let(:deployment_plan) { deployment_plans.first }

        describe 'the arguments to the deployment plan are the chosen sensors' do
          subject { deployment_plan.arguments[LV.sensor] }

          it { is_expected.to include kitchen_sensor_1.node }
          it { is_expected.to include bedroom_sensor.node }
        end
      end
    end
  end
end
