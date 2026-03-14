# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveKaleidoscope::Client do
  subject(:client) { described_class.new }

  it 'includes the runner module' do
    expect(described_class.ancestors).to include(
      Legion::Extensions::CognitiveKaleidoscope::Runners::CognitiveKaleidoscope
    )
  end

  it 'responds to create_facet' do
    expect(client).to respond_to(:create_facet)
  end

  it 'responds to create_pattern' do
    expect(client).to respond_to(:create_pattern)
  end

  it 'responds to rotate' do
    expect(client).to respond_to(:rotate)
  end

  it 'responds to polish' do
    expect(client).to respond_to(:polish)
  end

  it 'responds to kaleidoscope_status' do
    expect(client).to respond_to(:kaleidoscope_status)
  end

  it 'can create facet and pattern through client' do
    facet_result = client.create_facet(facet_type: :belief, domain: :test, content: 'x')
    expect(facet_result[:success]).to be true
    pattern_result = client.create_pattern
    expect(pattern_result[:success]).to be true
  end
end
