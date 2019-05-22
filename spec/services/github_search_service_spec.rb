require_relative '../spec_helper'
require_relative '../../services/github_search_service'

describe GithubSearchService do
  let(:instance) { described_class.new(search_text) }

  describe '#initialize' do
    let(:search_text) { 'text_text' }

    it do
      expect(instance.error).to be_nil
      expect(instance.result).to eq []
      expect{ instance.search_text }.to raise_error(NoMethodError)
    end
  end

  describe '#call' do
    context 'when nil search_text' do
      let(:search_text) { nil }

      it_behaves_like 'invalid search text'
    end

    context 'when empty search_text' do
      let(:search_text) { '' }

      it_behaves_like 'invalid search text'
    end

    context 'when blank search_text' do
      let(:search_text) { '   ' }

      it_behaves_like 'invalid search text'
    end

    context 'when valid search_text' do
      let(:search_text) { 'text_text' }

      before do 
        allow(instance).to receive(:response) { {'items' => [:item_1]} }
        instance.call
      end

      it do
        expect(instance.error).to be_nil
        expect(instance.result).to eq [:item_1]
      end
    end

    context 'when any error' do
      let(:search_text) { 'text_text' }

      before do 
        allow(instance).to receive(:response) { {'error' => :any_error} }
        instance.call
      end

      it do
        expect(instance.error).to eq :any_error
        expect(instance.result).to eq []
      end
    end
  end

  describe '#api_url' do
    let(:search_text) { 'text_text' }

    it do
      expect(instance.send(:api_url)).to eq "https://api.github.com/search/repositories?q=#{search_text}"
    end
  end
end
