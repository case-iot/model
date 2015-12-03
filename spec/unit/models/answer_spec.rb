require_relative '../spec_helper'

describe Answer do
  let(:repo) do
    RDF::Repository.new do |r|
      # DEVICE
      r << [:dev, RDF.type, LV.Device]
      r << [:dev, LV.manufacturer_name, 'Grundfos']
      r << [:dev, LV.located_at, :device_location]
      # QUESTION
      r << [:device_location, RDF.type, QV.question_type]
      r << [:device_location, QV.reply_type, QV.location]
      r << [:device_location, QV.location_of, :dev]
      r << [:device_location, QV.text, 'Where is the thing?']
      # ANSWER
      r << [:device_location, QV.has_answer, :answer]
      r << [:answer, RDF.type, QV.answer_type]
      r << [:answer, QV.answers, :device_location]
      r << [:answer, RDF.type, QV.location]
      r << [:answer, LV.location_name, 'Living Room']
    end
  end

  let(:ontology) { Ontology.new(repo) }
  let(:answer) { Answer.new(:device_location, repo) }

  context '#question.text' do
    subject { answer.question.text }
    it { is_expected.not_to eq(nil) }
    it { is_expected.to eq('Where is the thing?') }
  end

  context '#reply_type' do
    subject { answer.reply_type }
    it { is_expected.to eq(:location) }
  end

  context '#value' do
    let(:value) { answer.value }

    context '#name' do
      subject { value.name }
      it { is_expected.to eq('Living Room') }
    end

    context '#name=' do
      before :each do
        value.name = 'Kitchen'
      end

      subject { value.name }
      it { is_expected.to eq('Kitchen') }

      describe 'new instances should have the changed value' do
        let(:new_answer) { Answer.new(:device_location, repo) }

        subject { new_answer.value.name }
        it { is_expected.to eq('Kitchen') }
      end

      describe 'location of the device changes as well' do
        let(:device) { Device.new(:dev, repo) }

        subject { device.location.name }
        it { is_expected.to eq('Kitchen') }
      end
    end
  end
end
