require_relative '../spec_helper'

describe NodeBuilder do
  let(:repo) do
    RDF::Repository.new do |repo|
      repo << [LV.john, LV.knows, LV.jane]
    end
  end

  context '.create' do
    describe 'generate a device node' do
      let(:node) do
        NodeBuilder.create({
          RDF.type => [
            LV.Device,
            LV.Irrigator,
            LV.EcosystemHost
          ],
          LV.manufacturerName => 'Apple',
          LV.description => 'Insanely great',
          LV.locatedAt => {
            LV.locationName => 'Cupertino'
          }
        },
        repo)
      end
      let(:device) { Device.new(node, repo) }

      context '#manufacturer_name' do
        subject { device.manufacturer_name }
        it { is_expected.to eq 'Apple' }
      end

      context '#description' do
        subject { device.description }
        it { is_expected.to eq 'Insanely great' }
      end

      context '#location' do
        let(:location) { device.location }

        context '#name' do
          subject { location.name }
          it { is_expected.to eq 'Cupertino' }
        end
      end

      context '#types' do
        subject do
          NodeQuery.new(node, repo).values(RDF.type).size
        end
        it { is_expected.to eq 3 }
      end
    end
  end
end
