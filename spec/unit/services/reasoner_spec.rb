require_relative '../spec_helper'

describe Reasoner do
  let(:repo) { RDF::Repository.new }
  let(:reasoner) { Reasoner.new(repo) }
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
end
