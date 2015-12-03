require_relative '../spec_helper'

describe 'an app for controlling a thermostat' do

  let(:repo) { RDF::Repository.new }
  let(:ontology) { Ontology.new(repo) }

  before { load_app_definition(repo) }

  let(:app) { ontology.applications.first }

  let(:open_question) { app.open_questions.first }

  describe 'the app not compatible yet' do
    subject { app.compatible? }
    it { is_expected.to eq false }
  end

  describe 'there is an unanswered question' do
    subject { open_question.text }
    it { is_expected.to eq 'What is the target temperature?' }
  end

  describe 'answering the question with setting it to 22 degrees' do
    let(:answer) { open_question.answer! }
    before { answer.value.in_celsius = 22 }

    describe 'there are no open questions anymore' do
      subject { app.open_questions.any? }
      it { is_expected.to eq false }
    end

    describe 'the app is still not compatible' do
      subject { app.compatible? }
      it { is_expected.to eq false }
    end

    let(:thermostat_requirement) do
      app.requirements.find { |r| r.description == 'Thermostat needed' }
    end

    describe 'there is an unsatisfied requirement for a thermostat' do
      subject { thermostat_requirement.satisfied? }
      it { is_expected.to eq false }
    end

    describe 'starting the thermostat' do
      before { load_thermostat_definition(repo) }
      let(:thermostat) { ontology.devices.first }

      describe 'the requirement is satisfied' do
        subject { thermostat_requirement.satisfied? }
        it { is_expected.to eq true }
      end

      describe 'the app is compatible now' do
        subject { app.compatible? }
        it { is_expected.to eq true }
      end
    end
  end
end

def load_thermostat_definition(repo)
  read_def(repo, File.dirname(__FILE__) + '/thermostat.n3')
end

def load_app_definition(repo)
  read_def(repo, File.dirname(__FILE__) + '/thermostat_control_app.n3')
end
