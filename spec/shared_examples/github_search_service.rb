RSpec.shared_examples 'invalid search text' do
  it do
    expect(instance.error).to be_nil
    expect(instance.result).to eq []
  end
end
