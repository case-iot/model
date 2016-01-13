require_relative 'spec_helper'

describe 'an app that turns on the light when there is movement' do
  let(:repo) { RDF::Repository.new }
  let(:ontology) { Ontology.new(repo) }

  before do # load the app
    load_light_control_app(repo)
  end

  before do # start the devices
    load_kitchen_light(repo)
    load_kitchen_movement_sensor(repo)
  end

  let(:app) { ontology.applications.first }

  describe 'the install action' do
    let(:action) { app.action_with_description('Install') }

    it 'is not compatible yet' do
      expect(action.compatible?).to eq false
    end

    describe 'answering the question' do
      let(:question) { action.questions.first }

      describe 'the question' do
        subject { question.text }
        it { is_expected.to eq 'Where do you want to control the lights?' }
      end

      it 'is unanswered' do
        expect(question.has_answer?).to eq false
      end

      describe 'answering the question with location Bathroom' do
        let(:answer) { question.answer! }
        before { answer.value.name = 'Bathroom' }

        it 'is not compatible because there are no devices in the bathroom' do
          expect(action.compatible?).to eq false
        end
      end

      describe 'answering the question with location Kitchen' do
        let(:answer) { question.answer! }
        before { answer.value.name = 'Kitchen' }

        it 'is compatible now' do
          expect(action.compatible?).to eq true
        end

        describe 'performing the action' do
          let(:subscribe_url) { 'http://140.129.123.12/subscribe' }
          let(:notify_url) { 'http://140.129.133.21/turn_on' }

          before { stub_request(:post, subscribe_url) }
          before { action.perform }

          it 'made a request with the notify callback' do
            expect(WebMock).to have_requested(:post, subscribe_url).
              with(body: notify_url)
          end
        end
      end
    end
  end
end
