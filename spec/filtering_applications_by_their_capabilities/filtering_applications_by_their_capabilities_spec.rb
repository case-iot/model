require_relative 'spec_helper'

describe 'filtering applications by their capabilities' do

  let(:ontology) { Ontology.new(RDF::Repository.new) }
  let(:loader) { FilteringApplicationsByTheirCapabilitiesLoader.new(ontology) }
  let(:finder) { ApplicationByCapabilityFinder.new(ontology) }

  # initialize devices for the irrigation apps
  let!(:moisture_sensor) { loader.moisture_sensor }
  let!(:ph_sensor) { loader.ph_sensor }
  let!(:central_pivot) { loader.central_pivot_irrigator }
  let!(:sprinkler) { loader.sprinkler }

  # initialize devices for the smart home apps
  let!(:kitchen_light) { loader.kitchen_light }
  let!(:bedroom_light) { loader.bedroom_light }
  let!(:kitchen_movement_sensor) { loader.kitchen_movement_sensor }
  let!(:bedroom_smoke_detector) { loader.bedroom_smoke_detector }

  before { loader.apps }

  let(:app_names) { apps.map {|app| app.name }.sort }
  subject { app_names }

  describe 'applications for irrigation' do
    let(:apps) { finder.find_by_type(LV.Irrigation) }

    it { is_expected.to eq([
      'CerealsIrrigator', 'GrassIrrigator', 'WineIrrigator'
    ]) }
  end

  describe 'apps that use a sensor with type moisture sensor' do
    let(:apps) { finder.find_by_sensor({ LV.sensorType => LV.moistureSensor }) }

    it { is_expected.to eq([ 'CerealsIrrigator', 'WineIrrigator' ]) }
  end

  describe 'apps that use a Ph sensor' do
    let(:apps) { finder.find_by_sensor({ LV.sensorType => LV.phSensor }) }

    it { is_expected.to eq([ 'GrassIrrigator' ]) }
  end

  describe 'apps that use the sprinkler' do
    let(:apps) { finder.find_by_actuator(sprinkler.node) }

    it { is_expected.to eq([ 'GrassIrrigator', 'WineIrrigator' ]) }
  end

  describe 'apps for irrigating grass' do
    let(:apps) { finder.find({ LV.cropType => 'Grass' }) }

    it { is_expected.to eq([ 'GrassIrrigator' ]) }
  end

  describe 'apps that irrigate wine and use the sprnkler' do
    let(:apps) { finder.find({
      LV.cropType => 'Grass',
      LV.actuator => sprinkler.node
    }) }

    it { is_expected.to eq([ 'GrassIrrigator' ]) }
  end

  describe 'alarm applications' do
    let(:apps) { finder.find_by_type(LV.Alarm) }

    it { is_expected.to eq([ 'LightFire', 'LightMovement' ]) }
  end

  describe 'applications for the kitchen' do
    let(:apps) { finder.find({ LV.locationName => 'Kitchen' }) }

    it { is_expected.to eq([ 'LightMovement' ]) }
  end

  describe 'applications for the bedroom' do
    let(:apps) { finder.find({ LV.locationName => 'Bedroom' }) }

    it { is_expected.to eq([ 'LightFire' ]) }
  end
end
