require_relative '../spec_helper'

describe Reasoner do
  let(:repo) { RDF::Repository.new }
  let(:reasoner) { Reasoner.new(Ontology.new(repo)) }
  let(:person1) { RDF::Query::Variable.new(:p1) }
  let(:person2) { RDF::Query::Variable.new(:p2) }

  before do
    repo << [LV.john, LV.knows, LV.jane]
    repo << [person1, LV.knows, person2, :precondition]
    repo << [person1, LV.doesnt_know, person2, :wrong_precondition]
  end

  context '#check_condition' do
    describe 'correct condition' do
      subject { reasoner.check_condition(:precondition) }
      it { is_expected.to eq true }
    end

    describe 'wrong condition' do
      subject { reasoner.check_condition(:wrong_precondition) }
      it { is_expected.to eq false }
    end
  end

  context '#imply' do
    before :each do
      repo << [person2, LV.knows, person1, :postcondition]
    end

    describe 'correct precondition' do
      let!(:result) { reasoner.imply(:precondition, :postcondition) }

      it 'should find that Jane knows John' do
        expect(result.query([LV.jane, LV.knows, LV.john]).size).
          to eq(1)
      end

      it 'should not modify the source repository' do
        expect(repo.query([LV.jane, LV.knows, LV.john]).size).
          to eq(0)
        expect(repo.query([LV.john, LV.knows, LV.jane]).size).
          to eq(1)
      end
    end

    describe 'wrong precondition' do
      let!(:result) { reasoner.imply(:wrong_precondition, :postcondition) }

      it 'should not find that Jane knows John' do
        expect(result.query([LV.jane, LV.knows, LV.john]).size).
          to eq(0)
      end
    end
  end

  context '#load_and_process_n3' do
    let(:n3_input) { '@prefix c: <http://matus.tomlein.org/case/>.
                     c:dog c:likes c:cat.
                     { ?dog c:likes ?cat } => { ?cat c:likes ?dog }.' }
    let(:repo) { RDF::Repository.new }

    before { reasoner.load_and_process_n3(n3_input) }

    describe 'the known fact' do
      subject { repo.query([LV.dog, LV.likes, LV.cat]).any? }
      it { is_expected.to eq true }
    end

    describe 'the implied fact' do
      subject { repo.query([LV.cat, LV.likes, LV.dog]).any? }
      it { is_expected.to eq true }
    end
  end
end
