require_relative '../spec_helper'
require_relative '../../services/github_search_service'

describe GithubSearchService do
  let(:instance) { described_class.new(search_text) }

  describe '#initialize' do
    let(:search_text) { 'text_text' }
    context 'when without page' do
      it do
        expect(instance.error).to be_nil
        expect(instance.result).to eq []
        expect{ instance.search_text }.to raise_error(NoMethodError)
        expect(instance.send(:search_text)).to eq search_text
        expect{ instance.page }.to raise_error(NoMethodError)
        expect(instance.send(:page)).to eq 1
      end
    end

    context 'when valid page' do
      let(:instance) { described_class.new(search_text, page) }
      let(:page) { 2 }

      it do
        expect(instance.send(:page)).to eq 2
      end
    end

    context 'when invalid page' do
      let(:instance) { described_class.new(search_text, page) }
      let(:page) { 'text' }

      it do
        expect(instance.send(:page)).to eq 0
      end
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

    context 'when without page' do
      it do
        expect(instance.send(:api_url)).to eq "https://api.github.com/search/repositories?q=#{search_text}&page=1"
      end
    end

    context 'when with page' do
      let(:instance) { described_class.new(search_text, page) }
      let(:page) { 2 }

      it do
        expect(instance.send(:api_url))
          .to eq "https://api.github.com/search/repositories?q=#{search_text}&page=#{page}"
      end
    end
  end
end
