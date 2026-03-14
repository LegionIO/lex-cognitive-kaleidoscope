# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveKaleidoscope::Helpers::Constants do
  described_class = Legion::Extensions::CognitiveKaleidoscope::Helpers::Constants

  describe 'FACET_TYPES' do
    it 'contains expected types' do
      expect(described_class::FACET_TYPES).to eq(%i[belief experience emotion memory intuition])
    end

    it 'is frozen' do
      expect(described_class::FACET_TYPES).to be_frozen
    end
  end

  describe 'SYMMETRY_TYPES' do
    it 'contains expected types' do
      expect(described_class::SYMMETRY_TYPES).to eq(%i[bilateral radial rotational asymmetric])
    end
  end

  describe 'ROTATION_MODES' do
    it 'contains expected modes' do
      expect(described_class::ROTATION_MODES).to eq(%i[slow steady rapid chaotic])
    end
  end

  describe 'numeric constants' do
    it 'defines MAX_FACETS' do
      expect(described_class::MAX_FACETS).to eq(500)
    end

    it 'defines MAX_PATTERNS' do
      expect(described_class::MAX_PATTERNS).to eq(100)
    end

    it 'defines ROTATION_STEP' do
      expect(described_class::ROTATION_STEP).to eq(0.1)
    end

    it 'defines DECAY_RATE' do
      expect(described_class::DECAY_RATE).to eq(0.02)
    end
  end

  describe '.label_for' do
    context 'with BRILLIANCE_LABELS' do
      it 'returns :dazzling for high values' do
        expect(described_class.label_for(described_class::BRILLIANCE_LABELS, 0.9)).to eq(:dazzling)
      end

      it 'returns :vivid for 0.7' do
        expect(described_class.label_for(described_class::BRILLIANCE_LABELS, 0.7)).to eq(:vivid)
      end

      it 'returns :moderate for 0.5' do
        expect(described_class.label_for(described_class::BRILLIANCE_LABELS, 0.5)).to eq(:moderate)
      end

      it 'returns :dim for 0.3' do
        expect(described_class.label_for(described_class::BRILLIANCE_LABELS, 0.3)).to eq(:dim)
      end

      it 'returns :dark for 0.1' do
        expect(described_class.label_for(described_class::BRILLIANCE_LABELS, 0.1)).to eq(:dark)
      end
    end

    context 'with COMPLEXITY_LABELS' do
      it 'returns :fractal for 0.9' do
        expect(described_class.label_for(described_class::COMPLEXITY_LABELS, 0.9)).to eq(:fractal)
      end

      it 'returns :minimal for 0.1' do
        expect(described_class.label_for(described_class::COMPLEXITY_LABELS, 0.1)).to eq(:minimal)
      end
    end
  end
end
