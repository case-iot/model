require_relative '../spec_helper'

describe Question do
  let(:repo) do
    RDF::Repository.new do |r|
      r << [:a, RDF.type, LV.Application]
      r << [:device_location, RDF.type, QV.question_type]
      r << [:device_location, QV.text, 'Where is the thing?']
      r << [:device_location, QV.reply_type, QV.location]
      r << [:device_location, QV.location_of, :device]
      r << [:dev, RDF.type, LV.Device]
      r << [:dev, LV.manufacturer_name, 'Apple']
    end
  end

  let(:ontology) { Ontology.new(repo) }
  let(:question) { Question.new(:device_location, repo) }

  context '#text' do
    subject { question.text }
    it { is_expected.to eq('Where is the thing?') }
  end

  context '#reply_type' do
    subject { question.reply_type }
    it { is_expected.to eq(:location) }
  end

  describe 'without answer' do
    context '#has_answer?' do
      subject { question.has_answer? }
      it { is_expected.to eq(false) }
    end

    context '#answer' do
      subject { question.answer }
      it { is_expected.to eq(nil) }
    end

    context '#answer!' do
      let(:answer) { question.answer! }

      subject { answer }
      it { is_expected.not_to eq(nil) }

      describe 'location answer properties' do
        before :each do
          answer.value.name = 'Balcony'
        end

        subject { answer.value.name }
        it { is_expected.to eq('Balcony') }

        describe 'creates a link to the location from device' do
          let(:device) { Device.new(:dev, repo) }
          subject { device.location.name }
          it { is_expected.to eq('Balcony') }
        end
      end
    end
  end

  describe 'with answer' do
    before :each do
      repo << [:answer, RDF.type, QV.answer_type]
      repo << [:answer, QV.answers, :device_location]
      repo << [:device_location, QV.has_answer, :answer]
    end

    context '#has_answer?' do
      subject { question.has_answer? }
      it { is_expected.to eq(true) }
    end

    context '#answer' do
      let(:answer) { question.answer }
      subject { answer }

      it { is_expected.not_to eq(nil) }

      context '#question.text' do
        subject { answer.question.text }
        it { is_expected.to eq(question.text) }
      end
    end

    context '#answer!' do
      it 'should have the same value as calling answer' do
        with_bang = question.answer!.value.name
        without_bang = question.answer.value.name
        expect(with_bang).to eq(without_bang)
      end
    end
  end
end
