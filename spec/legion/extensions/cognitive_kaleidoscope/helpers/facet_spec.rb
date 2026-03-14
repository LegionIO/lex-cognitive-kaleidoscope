# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveKaleidoscope::Helpers::Facet do
  subject(:facet) do
    described_class.new(facet_type: :belief, domain: :reasoning, content: 'core principle')
  end

  describe '#initialize' do
    it 'assigns a UUID id' do
      expect(facet.id).to match(/\A[0-9a-f-]{36}\z/)
    end

    it 'sets facet_type as symbol' do
      expect(facet.facet_type).to eq(:belief)
    end

    it 'sets domain as symbol' do
      expect(facet.domain).to eq(:reasoning)
    end

    it 'stores content' do
      expect(facet.content).to eq('core principle')
    end

    it 'defaults brilliance to 0.7' do
      expect(facet.brilliance).to eq(0.7)
    end

    it 'defaults transparency to 0.5' do
      expect(facet.transparency).to eq(0.5)
    end

    it 'defaults angle to 0.0' do
      expect(facet.angle).to eq(0.0)
    end

    it 'accepts custom brilliance' do
      f = described_class.new(facet_type: :emotion, domain: :test, content: 'x', brilliance: 0.3)
      expect(f.brilliance).to eq(0.3)
    end

    it 'clamps brilliance to 0..1' do
      f = described_class.new(facet_type: :memory, domain: :test, content: 'x', brilliance: 5.0)
      expect(f.brilliance).to eq(1.0)
    end

    it 'clamps angle to 0..360' do
      f = described_class.new(facet_type: :intuition, domain: :test, content: 'x', angle: 500.0)
      expect(f.angle).to eq(360.0)
    end

    it 'raises on unknown facet type' do
      expect do
        described_class.new(facet_type: :plasma, domain: :test, content: 'x')
      end.to raise_error(ArgumentError, /unknown facet type/)
    end

    it 'sets created_at' do
      expect(facet.created_at).to be_a(Time)
    end
  end

  describe '#rotate!' do
    it 'increases angle' do
      facet.rotate!(degrees: 45)
      expect(facet.angle).to eq(45.0)
    end

    it 'wraps around at 360' do
      facet.rotate!(degrees: 400)
      expect(facet.angle).to eq(40.0)
    end
  end

  describe '#polish!' do
    it 'increases brilliance' do
      initial = facet.brilliance
      facet.polish!(rate: 0.1)
      expect(facet.brilliance).to eq((initial + 0.1).round(10))
    end

    it 'clamps at 1.0' do
      facet.polish!(rate: 5.0)
      expect(facet.brilliance).to eq(1.0)
    end
  end

  describe '#tarnish!' do
    it 'decreases brilliance' do
      initial = facet.brilliance
      facet.tarnish!
      expect(facet.brilliance).to be < initial
    end
  end

  describe '#dazzling?' do
    it 'returns false at default' do
      expect(facet).not_to be_dazzling
    end

    it 'returns true when brilliance >= 0.8' do
      facet.brilliance = 0.85
      expect(facet).to be_dazzling
    end
  end

  describe '#dark?' do
    it 'returns false at default' do
      expect(facet).not_to be_dark
    end

    it 'returns true when brilliance < 0.2' do
      facet.brilliance = 0.1
      expect(facet).to be_dark
    end
  end

  describe '#opaque?' do
    it 'returns false at default transparency' do
      expect(facet).not_to be_opaque
    end

    it 'returns true when transparency < 0.2' do
      facet.transparency = 0.1
      expect(facet).to be_opaque
    end
  end

  describe '#clear?' do
    it 'returns false at default' do
      expect(facet).not_to be_clear
    end

    it 'returns true when transparency >= 0.8' do
      facet.transparency = 0.9
      expect(facet).to be_clear
    end
  end

  describe '#brilliance_label' do
    it 'returns :vivid at default' do
      expect(facet.brilliance_label).to eq(:vivid)
    end
  end

  describe '#to_h' do
    subject(:hash) { facet.to_h }

    it 'includes all expected keys' do
      expected = %i[id facet_type domain content brilliance transparency
                    angle brilliance_label dazzling dark created_at]
      expect(hash.keys).to match_array(expected)
    end
  end
end
