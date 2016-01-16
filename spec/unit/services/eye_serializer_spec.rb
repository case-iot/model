require_relative '../spec_helper'

describe EyeSerializer do
  let(:p1) { RDF::Query::Variable.new(:p1) }
  let(:p2) { RDF::Query::Variable.new(:p2) }
  let(:facts) do
    RDF::Graph.new do |g|
      g << [LV.john, LV.knows, LV.jane]
    end
  end
  let(:precondition) do
    RDF::Graph.new do |g|
      g << [p1, LV.knows, p2]
    end
  end
  let(:postcondition) do
    RDF::Graph.new do |g|
      g << [p2, LV.knows, p1]
    end
  end

  context '.serialize_implication' do

    subject { EyeSerializer.serialize_implication(facts, precondition, postcondition) }

    it do
      is_expected.to eq('<http://matus.tomlein.org/case/john> <http://matus.tomlein.org/case/knows> <http://matus.tomlein.org/case/jane> .
{?p1 <http://matus.tomlein.org/case/knows> ?p2 .
} => {?p2 <http://matus.tomlein.org/case/knows> ?p1 .
}.
')
    end
  end
end
