require_relative '../spec_helper'

describe HttpRequest do
  let(:repo) { RDF::Repository.new }
  let(:ontology) { Ontology.new(repo) }
  let(:request) { HttpRequest.new(:r, repo) }

  before do
    repo << [ :r, HttpVocabulary.method_name, 'POST' ]
    repo << [ :r, HttpVocabulary.body, 'the body' ]
  end

  context '#uri' do
    subject { request.uri }

    describe 'as literal' do
      before { repo << [ :r, HttpVocabulary.request_uri, 'http://example.com' ] }

      it { is_expected.to eq 'http://example.com' }
    end

    describe 'as URI' do
      before { repo << [ :r, HttpVocabulary.request_uri, RDF::URI('http://example.eu') ] }

      it { is_expected.to eq 'http://example.eu' }
    end
  end

  context '#execute' do
    before do
      repo << [ :r, HttpVocabulary.request_uri, 'http://example.com' ]
      stub_request(:post, 'example.com')
    end

    it 'makes the request' do
      expect(request.execute).to eq true

      expect(WebMock).to have_requested(:post, 'example.com').
          with(:body => 'the body')
    end
  end
end
