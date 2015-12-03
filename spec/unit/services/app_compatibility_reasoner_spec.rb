require_relative '../spec_helper'

describe AppCompatibilityReasoner do
  let(:repo) do
    RDF::Repository.new { |r| r << [:app, RDF.type, LV.Application] }
  end
  let(:ontology) { Ontology.new(repo) }
  let(:app) { Application.new(:app, repo) }

  context '#compatible?' do
    subject { app.compatible? }

    describe 'simple app that requires a thermostat' do
      before :each do
        device1 = RDF::Query::Variable.new(:device1)
        repo << [ :app, LV.compatibility_condition, :compatibility_graph ]
        repo << [ device1, RDF.type, LV.thermostat, :compatibility_graph ]
      end

      describe 'compatible app' do
        before :each do
          repo << [ :nest, RDF.type, LV.thermostat ]
        end

        it { is_expected.to eq(true) }
      end

      describe 'incompatible app' do
        it { is_expected.to eq(false) }
      end
    end
  end
end
