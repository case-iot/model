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
      r << [:device_location, QV.reply_type, QV.Location]
      r << [:device_location, QV.location_of, :dev]
      r << [:device_location, QV.text, 'Where is the thing?']
      # ANSWER
      r << [:device_location, QV.has_answer, :answer]
      r << [:answer, RDF.type, QV.answer_type]
      r << [:answer, QV.answers, :device_location]
      r << [:answer, RDF.type, QV.Location]
      r << [:answer, LV.location_name, 'Living Room']
    end
  end

  let(:ontology) { Ontology.new(repo) }
  let(:question) { Question.new(:device_location, ontology) }
  let(:answer) { question.answer }

  context '#question.text' do
    subject { answer.question.text }
    it { is_expected.not_to eq(nil) }
    it { is_expected.to eq('Where is the thing?') }
  end

  context '#reply_type' do
    subject { answer.reply_type }
    it { is_expected.to eq(:location) }
  end

  describe 'should have type Location' do
    subject { answer }
    it { is_expected.to be_kind_of Location }
  end
end
