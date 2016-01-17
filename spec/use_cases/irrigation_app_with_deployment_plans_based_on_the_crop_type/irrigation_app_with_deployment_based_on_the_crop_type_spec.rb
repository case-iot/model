require_relative 'spec_helper'

describe 'an app with different requirements and deployment plans based on the crop type' do

  let(:repo) { RDF::Repository.new }
  let(:ontology) { Ontology.new(repo) }
  let(:loader) { IrrigationAppWithDeploymentBasedOnTheCropTypeLoader.new(ontology) }

  before { loader.app }
  let!(:moisture_sensor) { loader.moisture_sensor }

  let(:app) { ontology.applications.first }
  let(:deployment_plans) { app.deployment_plans }
  let(:requirements) { app.requirements }

  it 'finds no requirements and no deployment plans yet' do
    expect(deployment_plans.any?).to eq false
    expect(requirements.any?).to eq false
  end

  let(:question) { app.questions.first }

  describe 'the question' do
    subject { question.text }
    it { is_expected.to eq 'What is the crop type?' }
  end

  let(:answer) { question.answer! }

  describe 'options of the question' do
    subject { answer.options }
    it { is_expected.to eq [ 'Cereals', 'Wine' ] }
  end

  describe 'choose Wine as the crop type' do
    before { answer.selected = 'Wine' }
    before { ontology.refresh }

    describe 'there should be one requirement' do
      subject { requirements.size }
      it { is_expected.to eq 1 }
    end

    let(:requirement) { requirements.first }

    describe 'the requirement' do
      subject { requirement.description }
      it { is_expected.to eq 'Irrigator and sensors for wine needed' }
    end

    describe 'addding irrigators for cereals won\'t satisfy this requirement' do
      before { loader.cereal_irrigator }
      before { loader.cereal_irrigator }
      before { ontology.refresh }

      subject { requirement.satisfied? }
      it { is_expected.to eq false }
    end

    describe 'adding wine irrigators' do
      let!(:irrigator) { loader.wine_irrigator }
      before { ontology.refresh }

      describe 'requirement is satisfied' do
        subject { requirement.satisfied? }
        it { is_expected.to eq true }
      end

      describe 'there is one deployment plans' do
        subject { deployment_plans.size }
        it { is_expected.to eq 1 }
      end

      let(:deployment_plan) { deployment_plans.first }

      describe 'the description of the plan' do
        subject { deployment_plan.description }
        it { is_expected.to eq 'Irrigation of wine' }
      end

      describe 'the host' do
        subject { deployment_plan.host.node }
        it { is_expected.to eq irrigator.node }
      end

      describe 'the arguments' do
        subject { deployment_plan.arguments }
        it { is_expected.to eq({ LV.moistureSensor => moisture_sensor.node }) }
      end
    end
  end

  describe 'choose Cereals as the crop type' do
    before { answer.selected = 'Cereals' }
    before { ontology.refresh }

    describe 'there should be one requirement' do
      subject { requirements.size }
      it { is_expected.to eq 1 }
    end

    let(:requirement) { requirements.first }

    describe 'the requirement' do
      subject { requirement.description }
      it { is_expected.to eq 'Irrigator and sensors for cereals needed' }
    end

    describe 'addding irrigators for wine won\'t satisfy this requirement' do
      before { loader.wine_irrigator }
      before { loader.wine_irrigator }
      before { ontology.refresh }

      subject { requirement.satisfied? }
      it { is_expected.to eq false }
    end

    describe 'adding cereal irrigators' do
      let!(:irrigator1) { loader.cereal_irrigator }
      let!(:irrigator2) { loader.cereal_irrigator }
      before { ontology.refresh }

      describe 'requirement is satisfied' do
        subject { requirement.satisfied? }
        it { is_expected.to eq true }
      end

      describe 'there is one deployment plans' do
        subject { deployment_plans.size }
        it { is_expected.to eq 1 }
      end

      let(:deployment_plan) { deployment_plans.first }

      describe 'the description of the plan' do
        subject { deployment_plan.description }
        it { is_expected.to eq 'Irrigation of cereals' }
      end

      let(:subplans) { deployment_plan.deployment_plans }

      describe 'there are 2 sub-plans' do
        subject { subplans.size }
        it { is_expected.to eq 2 }
      end

      describe 'the hosts of the subplans' do
        subject { subplans.map {|p| p.host.node } }
        it { is_expected.to include irrigator1.node }
        it { is_expected.to include irrigator2.node }
      end
    end
  end
end
