# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveKaleidoscope::Runners::CognitiveKaleidoscope do
  let(:runner) do
    obj = Object.new
    obj.extend(described_class)
    obj
  end

  let(:engine) { Legion::Extensions::CognitiveKaleidoscope::Helpers::KaleidoscopeEngine.new }

  describe '#create_facet' do
    it 'returns success with facet hash' do
      result = runner.create_facet(facet_type: :belief, domain: :reasoning,
                                   content: 'test', engine: engine)
      expect(result[:success]).to be true
      expect(result[:facet][:facet_type]).to eq(:belief)
    end

    it 'returns failure for invalid type' do
      result = runner.create_facet(facet_type: :plasma, domain: :test,
                                   content: 'x', engine: engine)
      expect(result[:success]).to be false
      expect(result[:error]).to match(/unknown facet type/)
    end
  end

  describe '#create_pattern' do
    it 'returns success with pattern hash' do
      result = runner.create_pattern(engine: engine)
      expect(result[:success]).to be true
      expect(result[:pattern]).to be_a(Hash)
    end

    it 'accepts symmetry' do
      result = runner.create_pattern(symmetry: :bilateral, engine: engine)
      expect(result[:pattern][:symmetry]).to eq(:bilateral)
    end
  end

  describe '#add_to_pattern' do
    it 'links facet to pattern' do
      f = engine.create_facet(facet_type: :belief, domain: :t, content: 'x')
      p = engine.create_pattern
      result = runner.add_to_pattern(facet_id: f.id, pattern_id: p.id, engine: engine)
      expect(result[:success]).to be true
      expect(result[:status]).to eq(:added)
    end

    it 'returns failure for bad ids' do
      result = runner.add_to_pattern(facet_id: 'bad', pattern_id: 'bad', engine: engine)
      expect(result[:success]).to be false
    end
  end

  describe '#rotate' do
    it 'rotates a facet' do
      f = engine.create_facet(facet_type: :emotion, domain: :t, content: 'x')
      result = runner.rotate(facet_id: f.id, degrees: 90, engine: engine)
      expect(result[:success]).to be true
      expect(result[:facet][:angle]).to eq(90.0)
    end

    it 'rotates a pattern' do
      p = engine.create_pattern
      result = runner.rotate(pattern_id: p.id, degrees: 45, engine: engine)
      expect(result[:success]).to be true
      expect(result[:pattern]).to be_a(Hash)
    end

    it 'returns failure when neither given' do
      result = runner.rotate(engine: engine)
      expect(result[:success]).to be false
      expect(result[:error]).to match(/must provide/)
    end
  end

  describe '#polish' do
    it 'increases facet brilliance' do
      f = engine.create_facet(facet_type: :memory, domain: :t, content: 'x', brilliance: 0.5)
      result = runner.polish(facet_id: f.id, rate: 0.2, engine: engine)
      expect(result[:success]).to be true
      expect(result[:facet][:brilliance]).to eq(0.7)
    end
  end

  describe '#list_facets' do
    before do
      engine.create_facet(facet_type: :belief, domain: :t, content: 'a')
      engine.create_facet(facet_type: :emotion, domain: :t, content: 'b')
      engine.create_facet(facet_type: :belief, domain: :t, content: 'c')
    end

    it 'returns all facets' do
      result = runner.list_facets(engine: engine)
      expect(result[:count]).to eq(3)
    end

    it 'filters by facet_type' do
      result = runner.list_facets(facet_type: :belief, engine: engine)
      expect(result[:count]).to eq(2)
    end
  end

  describe '#kaleidoscope_status' do
    it 'returns a report' do
      result = runner.kaleidoscope_status(engine: engine)
      expect(result[:success]).to be true
      expect(result[:report]).to include(:total_facets, :avg_brilliance)
    end
  end
end
