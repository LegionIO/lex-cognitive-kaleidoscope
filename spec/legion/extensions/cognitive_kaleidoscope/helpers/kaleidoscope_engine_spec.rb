# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveKaleidoscope::Helpers::KaleidoscopeEngine do
  subject(:engine) { described_class.new }

  let(:default_attrs) { { facet_type: :belief, domain: :reasoning, content: 'test facet' } }

  describe '#create_facet' do
    it 'creates and stores a facet' do
      f = engine.create_facet(**default_attrs)
      expect(f).to be_a(Legion::Extensions::CognitiveKaleidoscope::Helpers::Facet)
      expect(engine.all_facets.size).to eq(1)
    end

    it 'raises when limit reached' do
      stub_const('Legion::Extensions::CognitiveKaleidoscope::Helpers::Constants::MAX_FACETS', 2)
      engine.create_facet(**default_attrs)
      engine.create_facet(facet_type: :emotion, domain: :test, content: 'x')
      expect do
        engine.create_facet(facet_type: :memory, domain: :test, content: 'y')
      end.to raise_error(ArgumentError, /facet limit/)
    end
  end

  describe '#create_pattern' do
    it 'creates and stores a pattern' do
      p = engine.create_pattern
      expect(p).to be_a(Legion::Extensions::CognitiveKaleidoscope::Helpers::Pattern)
      expect(engine.all_patterns.size).to eq(1)
    end

    it 'accepts symmetry parameter' do
      p = engine.create_pattern(symmetry: :bilateral)
      expect(p.symmetry).to eq(:bilateral)
    end

    it 'raises when limit reached' do
      stub_const('Legion::Extensions::CognitiveKaleidoscope::Helpers::Constants::MAX_PATTERNS', 1)
      engine.create_pattern
      expect { engine.create_pattern }.to raise_error(ArgumentError, /pattern limit/)
    end
  end

  describe '#add_facet_to_pattern' do
    it 'links a facet to a pattern' do
      f = engine.create_facet(**default_attrs)
      p = engine.create_pattern
      result = engine.add_facet_to_pattern(facet_id: f.id, pattern_id: p.id)
      expect(result).to eq(:added)
    end

    it 'raises for unknown facet' do
      p = engine.create_pattern
      expect do
        engine.add_facet_to_pattern(facet_id: 'bad', pattern_id: p.id)
      end.to raise_error(ArgumentError, /facet not found/)
    end

    it 'raises for unknown pattern' do
      f = engine.create_facet(**default_attrs)
      expect do
        engine.add_facet_to_pattern(facet_id: f.id, pattern_id: 'bad')
      end.to raise_error(ArgumentError, /pattern not found/)
    end
  end

  describe '#rotate_facet' do
    it 'rotates a facet' do
      f = engine.create_facet(**default_attrs)
      engine.rotate_facet(facet_id: f.id, degrees: 90)
      expect(f.angle).to eq(90.0)
    end
  end

  describe '#polish_facet' do
    it 'increases facet brilliance' do
      f = engine.create_facet(**default_attrs, brilliance: 0.5)
      engine.polish_facet(facet_id: f.id, rate: 0.2)
      expect(f.brilliance).to eq(0.7)
    end
  end

  describe '#rotate_pattern' do
    it 'rotates all facets in the pattern' do
      f = engine.create_facet(**default_attrs)
      p = engine.create_pattern
      engine.add_facet_to_pattern(facet_id: f.id, pattern_id: p.id)
      engine.rotate_pattern(pattern_id: p.id, degrees: 45)
      expect(f.angle).to eq(45.0)
    end
  end

  describe '#tarnish_all!' do
    it 'reduces brilliance on all facets' do
      f1 = engine.create_facet(**default_attrs)
      f2 = engine.create_facet(facet_type: :emotion, domain: :test, content: 'y')
      engine.tarnish_all!
      expect(f1.brilliance).to be < 0.7
      expect(f2.brilliance).to be < 0.7
    end
  end

  describe '#facets_by_type' do
    it 'returns counts per type' do
      engine.create_facet(**default_attrs)
      engine.create_facet(facet_type: :emotion, domain: :test, content: 'x')
      counts = engine.facets_by_type
      expect(counts[:belief]).to eq(1)
      expect(counts[:emotion]).to eq(1)
      expect(counts[:memory]).to eq(0)
    end
  end

  describe '#brightest' do
    it 'returns facets sorted by brilliance descending' do
      f1 = engine.create_facet(**default_attrs, brilliance: 0.3)
      f2 = engine.create_facet(facet_type: :emotion, domain: :t, content: 'x', brilliance: 0.9)
      expect(engine.brightest(limit: 2).first).to eq(f2)
      expect(engine.brightest(limit: 2).last).to eq(f1)
    end
  end

  describe '#dimmest' do
    it 'returns facets sorted by brilliance ascending' do
      f1 = engine.create_facet(**default_attrs, brilliance: 0.3)
      engine.create_facet(facet_type: :emotion, domain: :t, content: 'x', brilliance: 0.9)
      expect(engine.dimmest(limit: 1).first).to eq(f1)
    end
  end

  describe '#dazzling_facets' do
    it 'returns only dazzling facets' do
      engine.create_facet(**default_attrs, brilliance: 0.9)
      engine.create_facet(facet_type: :emotion, domain: :t, content: 'x', brilliance: 0.3)
      expect(engine.dazzling_facets.size).to eq(1)
    end
  end

  describe '#dark_facets' do
    it 'returns only dark facets' do
      engine.create_facet(**default_attrs, brilliance: 0.1)
      engine.create_facet(facet_type: :emotion, domain: :t, content: 'x', brilliance: 0.7)
      expect(engine.dark_facets.size).to eq(1)
    end
  end

  describe '#kaleidoscope_report' do
    it 'returns a comprehensive hash' do
      engine.create_facet(**default_attrs)
      engine.create_pattern
      report = engine.kaleidoscope_report
      expect(report).to include(
        :total_facets, :total_patterns, :by_type,
        :dazzling_count, :dark_count, :avg_brilliance, :avg_complexity
      )
    end

    it 'handles empty engine' do
      report = engine.kaleidoscope_report
      expect(report[:total_facets]).to eq(0)
      expect(report[:avg_brilliance]).to eq(0.0)
    end
  end
end
