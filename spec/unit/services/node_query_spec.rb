require_relative '../spec_helper'

describe NodeQuery do
  let(:repo) do
    RDF::Repository.new do |repo|
      repo << [LV.john, LV.knows, LV.jane]
    end
  end
  let(:query) { NodeQuery.new(LV.john, repo) }

  context '#value' do
    subject { query.value(LV.knows) }
    it { is_expected.to eq(LV.jane) }

    describe 'unset value' do
      subject { query.value(LV.hates) }
      it { is_expected.to eq(nil) }
    end
  end

  context '#values' do
    before :each do
      repo << [ LV.john, LV.knows, LV.emily ]
    end
    let(:values) { query.values(LV.knows) }

    context '#size' do
      subject { values.size }
      it { is_expected.to eq(2) }
    end

    context '#first' do
      subject { values.first }
      it { is_expected.to eq(LV.jane) }
    end

    context '#last' do
      subject { values.last }
      it { is_expected.to eq(LV.emily) }
    end

    describe 'size when unset value' do
      subject { query.values(LV.hates).size }
      it { is_expected.to eq(0) }
    end
  end

  context '#set_value' do
    before :each do
      query.set_value LV.loves, LV.jane
    end

    context '#value' do
      subject { query.value(LV.loves) }
      it { is_expected.to eq(LV.jane) }
    end

    describe 'overwrites previous value' do
      before :each do
        query.set_value LV.loves, LV.emily
      end

      context '#value' do
        subject { query.value(LV.loves) }
        it { is_expected.to eq(LV.emily) }
      end

      context '#values.size' do
        subject { query.values(LV.loves).size }
        it { is_expected.to eq(1) }
      end
    end
  end
end
