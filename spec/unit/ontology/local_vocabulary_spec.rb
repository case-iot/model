require_relative '../spec_helper'

describe LocalVocabulary do
  it 'returns a URI with the called method name' do
    uri = LocalVocabulary.Application.to_s
    expect(uri).to include('Application')
    expect(uri).to include('http')
  end
end
