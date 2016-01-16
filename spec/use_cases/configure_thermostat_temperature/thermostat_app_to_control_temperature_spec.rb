require_relative 'spec_helper'

describe 'an action for configuring a thermostat' do

  let(:repo) { RDF::Repository.new }
  let(:ontology) { Ontology.new(repo) }

  before { load_thermostat_app_definition(ontology) }
  let(:app) { ontology.applications.first }

  describe 'the question to set the temperature' do
    let(:deployment_plan) { app.deployment_plan_with_description('Update temperature') }
    let(:open_question) { app.open_questions.first }

    describe 'there is no deployment plan yet' do
      subject { deployment_plan.nil? }
      it { is_expected.to eq true }
    end

    describe 'the description of the question' do
      subject { open_question.text }
      it { is_expected.to eq 'What is the target temperature?' }
    end

    describe 'it is unanswered' do
      subject { open_question.has_answer? }
      it { is_expected.to eq false }
    end

    describe 'answering the question with setting it to 22 degrees' do
      let(:answer) { open_question.answer! }
      before { answer.in_celsius = 22 }
      before { ontology.refresh }

      describe 'the question has answer' do
        subject { open_question.has_answer? }
        it { is_expected.to eq true }
      end

      describe 'the deployment plan is active' do
        subject { deployment_plan.nil? }
        it { is_expected.to eq false }
      end

      describe 'argument for the deployment plan is the temperature' do
        subject { deployment_plan.arguments }
        it { is_expected.to eq [ 22 ] }
      end
    end
  end
end
