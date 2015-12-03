require_relative '../spec_helper'

describe Ontology do
  let(:repo) { RDF::Repository.new }
  let(:ontology) { Ontology.new(repo) }
  let(:requirement) { Requirement.new(:req, repo) }

  before do
    repo << [ :req, LV.description, 'This needs to be so and so.' ]
  end

  context '#description' do
    subject { requirement.description }
    it { is_expected.to eq('This needs to be so and so.') }
  end

  describe 'without question' do
    context '#has_question?' do
      subject { requirement.has_question? }
      it { is_expected.to eq false }
    end

    context '#question' do
      subject { requirement.question }
      it { is_expected.to eq nil }
    end

    context '#satisfied?' do
      before do
        repo << [ :req, LV.condition, :thermostat_required ]
        thermostat_var = RDF::Query::Variable.new(:thermostat)
        repo << [ thermostat_var, RDF.type, LV.thermostat, :thermostat_required ]
      end

      subject { requirement.satisfied? }

      describe 'without the thermostat' do
        it { is_expected.to eq false }
      end

      describe 'with the thermostat' do
        before do
          repo << [ :nest, RDF.type, LV.thermostat ]
        end

        it { is_expected.to eq true }
      end
    end
  end

  describe 'with question' do
    before do
      repo << [ :req, LV.requires_answering, :question ]
      repo << [ :question, LV.requires_answering, :question ]
      repo << [ :question, RDF.type, QV.question_type ]
      repo << [ :question, QV.reply_type, QV.temperature ]
      repo << [ :question, QV.text, 'Where is the thing?' ]
    end

    context '#has_question?' do
      subject { requirement.has_question? }
      it { is_expected.to eq true }
    end

    context '#question' do
      subject { requirement.question }
      it { is_expected.not_to eq nil }
    end

    context '#satisfied?' do
      subject { requirement.satisfied? }
      it { is_expected.to eq false }

      describe 'answering the question' do
        let(:question) { requirement.question }

        before do
          answer = question.answer!
          answer.value.in_celsius = 22
        end

        it { is_expected.to eq true }

        describe 'with condition on the answer' do
          let(:temp) { RDF::Query::Variable.new(:temp) }

          before do
            answer = RDF::Query::Variable.new(:answer)
            repo << [ :req, LV.condition, :temperature_bounds ]
            repo << [ :req, QV.has_answer, answer, :temperature_bounds ]
            repo << [ answer, LV.in_celsius, temp, :temperature_bounds ]
          end

          describe 'invalid' do
            before do
              repo << [ temp, MathVocabulary.less_than, 20, :temperature_bounds ]
            end

            it { is_expected.to eq false }
          end

          describe 'valid' do
            before do
              repo << [ temp, MathVocabulary.less_than, 25, :temperature_bounds ]
            end

            it { is_expected.to eq true }
          end
        end
      end
    end
  end
end
