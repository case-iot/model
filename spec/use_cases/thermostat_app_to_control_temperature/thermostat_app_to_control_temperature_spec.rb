require_relative 'spec_helper'

describe 'an app for controlling a thermostat' do

  let(:repo) { RDF::Repository.new }
  let(:ontology) { Ontology.new(repo) }

  before { load_app_definition(ontology) }
  let(:app) { ontology.applications.first }

  describe 'the install action' do
    let(:action) { app.action_with_description('Set temperature') }

    describe 'the action not compatible yet' do
      subject { action.compatible? }
      it { is_expected.to eq false }
    end

    let(:open_question) { action.open_questions.first }

    describe 'there is an unanswered question' do
      subject { open_question.text }
      it { is_expected.to eq 'What is the target temperature?' }
    end

    describe 'answering the question with setting it to 22 degrees' do
      let(:answer) { open_question.answer! }
      before { answer.value.in_celsius = 22 }
      before { ontology.refresh }

      describe 'there are no open questions anymore' do
        subject { action.open_questions.any? }
        it { is_expected.to eq false }
      end

      describe 'the action is still not compatible' do
        subject { action.compatible? }
        it { is_expected.to eq false }
      end

      let(:thermostat_requirement) do
        action.requirements.find { |r| r.description == 'Thermostat needed' }
      end

      describe 'there is an unsatisfied requirement for a thermostat' do
        subject { thermostat_requirement.satisfied? }
        it { is_expected.to eq false }
      end

      describe 'starting the thermostat' do
        before { load_thermostat_definition(ontology) }
        before { ontology.refresh }

        describe 'the requirement is satisfied' do
          subject { thermostat_requirement.satisfied? }
          it { is_expected.to eq true }
        end

        describe 'the action is compatible now' do
          subject { action.compatible? }
          it { is_expected.to eq true }
        end

        describe 'performing the action' do
          before { stub_request(:post, 'http://102.12.124.19/set_temp') }
          before { action.perform }

          it 'made a request with the desired temperature' do
            expect(WebMock).to have_requested(:post, 'http://102.12.124.19/set_temp').
              with(body: '22')
          end
        end
      end
    end
  end
end
