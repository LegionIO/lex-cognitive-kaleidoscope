# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveKaleidoscope::Helpers::Pattern do
  subject(:pattern) { described_class.new }

  describe '#initialize' do
    it 'assigns a UUID id' do
      expect(pattern.id).to match(/\A[0-9a-f-]{36}\z/)
    end

    it 'defaults symmetry to :radial' do
      expect(pattern.symmetry).to eq(:radial)
    end

    it 'defaults complexity to 0.5' do
      expect(pattern.complexity).to eq(0.5)
    end

    it 'defaults stability to 0.7' do
      expect(pattern.stability).to eq(0.7)
    end

    it 'starts with empty facet_ids' do
      expect(pattern.facet_ids).to be_empty
    end

    it 'raises on unknown symmetry' do
      expect do
        described_class.new(symmetry: :hexagonal)
      end.to raise_error(ArgumentError, /unknown symmetry/)
    end

    it 'accepts custom symmetry' do
      p = described_class.new(symmetry: :bilateral)
      expect(p.symmetry).to eq(:bilateral)
    end
  end

  describe '#add_facet' do
    it 'adds a facet id' do
      result = pattern.add_facet('facet-1')
      expect(result).to eq(:added)
      expect(pattern.facet_ids).to include('facet-1')
    end

    it 'returns :already_present for duplicates' do
      pattern.add_facet('facet-1')
      expect(pattern.add_facet('facet-1')).to eq(:already_present)
    end

    it 'recalculates complexity' do
      20.times { |i| pattern.add_facet("f-#{i}") }
      expect(pattern.complexity).to eq(1.0)
    end
  end

  describe '#remove_facet' do
    it 'removes a facet id' do
      pattern.add_facet('facet-1')
      expect(pattern.remove_facet('facet-1')).to eq(:removed)
      expect(pattern.facet_ids).not_to include('facet-1')
    end

    it 'returns :not_found for missing id' do
      expect(pattern.remove_facet('nope')).to eq(:not_found)
    end
  end

  describe '#rotate_all!' do
    it 'reduces stability slightly' do
      initial = pattern.stability
      pattern.rotate_all!(degrees: 90)
      expect(pattern.stability).to be < initial
    end
  end

  describe '#stabilize!' do
    it 'increases stability' do
      pattern.stability = 0.5
      pattern.stabilize!(rate: 0.1)
      expect(pattern.stability).to eq(0.6)
    end
  end

  describe '#destabilize!' do
    it 'decreases stability' do
      initial = pattern.stability
      pattern.destabilize!(rate: 0.1)
      expect(pattern.stability).to eq((initial - 0.1).round(10))
    end
  end

  describe '#fractal?' do
    it 'returns false at default' do
      expect(pattern).not_to be_fractal
    end

    it 'returns true when complexity >= 0.8' do
      pattern.complexity = 0.9
      expect(pattern).to be_fractal
    end
  end

  describe '#minimal?' do
    it 'returns false at default' do
      expect(pattern).not_to be_minimal
    end

    it 'returns true when complexity < 0.2' do
      pattern.complexity = 0.1
      expect(pattern).to be_minimal
    end
  end

  describe '#stable?' do
    it 'returns true at default' do
      expect(pattern).to be_stable
    end
  end

  describe '#chaotic?' do
    it 'returns false at default' do
      expect(pattern).not_to be_chaotic
    end

    it 'returns true when stability < 0.3' do
      pattern.stability = 0.2
      expect(pattern).to be_chaotic
    end
  end

  describe '#complexity_label' do
    it 'returns a symbol' do
      expect(pattern.complexity_label).to be_a(Symbol)
    end
  end

  describe '#facet_count' do
    it 'returns 0 initially' do
      expect(pattern.facet_count).to eq(0)
    end

    it 'tracks facet additions' do
      pattern.add_facet('f-1')
      pattern.add_facet('f-2')
      expect(pattern.facet_count).to eq(2)
    end
  end

  describe '#to_h' do
    it 'includes all expected keys' do
      expected = %i[id symmetry complexity stability complexity_label
                    facet_count fractal chaotic created_at]
      expect(pattern.to_h.keys).to match_array(expected)
    end
  end
end
