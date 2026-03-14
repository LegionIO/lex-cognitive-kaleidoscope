# frozen_string_literal: true

module Legion
  module Extensions
    module CognitiveKaleidoscope
      module Runners
        module CognitiveKaleidoscope
          extend self

          def create_facet(facet_type:, domain:, content:,
                           brilliance: nil, transparency: nil, angle: nil, engine: nil, **)
            eng = resolve_engine(engine)
            f   = eng.create_facet(facet_type: facet_type, domain: domain, content: content,
                                   brilliance: brilliance, transparency: transparency, angle: angle)
            { success: true, facet: f.to_h }
          rescue ArgumentError => e
            { success: false, error: e.message }
          end

          def create_pattern(symmetry: :radial, complexity: nil, stability: nil, engine: nil, **)
            eng = resolve_engine(engine)
            p   = eng.create_pattern(symmetry: symmetry, complexity: complexity, stability: stability)
            { success: true, pattern: p.to_h }
          rescue ArgumentError => e
            { success: false, error: e.message }
          end

          def add_to_pattern(facet_id:, pattern_id:, engine: nil, **)
            eng    = resolve_engine(engine)
            status = eng.add_facet_to_pattern(facet_id: facet_id, pattern_id: pattern_id)
            { success: true, status: status }
          rescue ArgumentError => e
            { success: false, error: e.message }
          end

          def rotate(facet_id: nil, pattern_id: nil, degrees: nil, engine: nil, **)
            eng = resolve_engine(engine)
            deg = degrees || (Helpers::Constants::ROTATION_STEP * 360)
            if pattern_id
              p = eng.rotate_pattern(pattern_id: pattern_id, degrees: deg)
              { success: true, pattern: p.to_h }
            elsif facet_id
              f = eng.rotate_facet(facet_id: facet_id, degrees: deg)
              { success: true, facet: f.to_h }
            else
              { success: false, error: 'must provide facet_id or pattern_id' }
            end
          rescue ArgumentError => e
            { success: false, error: e.message }
          end

          def polish(facet_id:, rate: nil, engine: nil, **)
            eng = resolve_engine(engine)
            f   = eng.polish_facet(facet_id: facet_id, rate: rate || 0.1)
            { success: true, facet: f.to_h }
          rescue ArgumentError => e
            { success: false, error: e.message }
          end

          def list_facets(engine: nil, facet_type: nil, **)
            eng     = resolve_engine(engine)
            results = eng.all_facets
            results = results.select { |f| f.facet_type == facet_type.to_sym } if facet_type
            { success: true, facets: results.map(&:to_h), count: results.size }
          end

          def kaleidoscope_status(engine: nil, **)
            eng = resolve_engine(engine)
            { success: true, report: eng.kaleidoscope_report }
          end

          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)

          private

          def resolve_engine(engine)
            engine || default_engine
          end

          def default_engine
            @default_engine ||= Helpers::KaleidoscopeEngine.new
          end
        end
      end
    end
  end
end
