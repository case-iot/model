require_relative '../spec_helper'

describe Question do
  let(:repo) do
    RDF::Repository.new do |r|
      r << [:a, RDF.type, QV.Application]
      r << [:question, RDF.type, QV.question_type]
      r << [:question, QV.text, 'Are you OK?']
      r << [:question, QV.replyType, QV.Select]
    end
  end

  let(:ontology) { Ontology.new(repo) }
  let(:question) { Question.new(:question, repo) }
  let(:answer) { question.answer! }

  context '#options' do
    subject { answer.options }

    describe 'options as a list of strings' do
      before do
        options = RDF::List[ 'opt1', 'opt2' ]
        repo << options
        repo << [:question, LV.options, options]
      end

      it { is_expected.to eq [ 'opt1', 'opt2' ] }
    end

    describe 'options as a set of strings' do
      before do
        repo << [:question, LV.option, 'opt1']
        repo << [:question, LV.option, 'opt2']
      end

      it { is_expected.to eq [ 'opt1', 'opt2' ] }
    end

    describe 'options as a set of nodes' do
      before do
        repo << [:question, LV.option, LV.opt1]
        repo << [:question, LV.option, LV.opt2]
      end

      it { is_expected.to eq [ LV.opt1, LV.opt2 ] }
    end
  end
end
