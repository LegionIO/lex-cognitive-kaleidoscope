# frozen_string_literal: true

module Legion
  module Extensions
    module CognitiveKaleidoscope
      module Helpers
        class Pattern
          attr_reader :id, :symmetry, :facet_ids, :created_at
          attr_accessor :complexity, :stability

          def initialize(symmetry: :radial, complexity: nil, stability: nil)
            validate_symmetry!(symmetry)
            @id         = SecureRandom.uuid
            @symmetry   = symmetry.to_sym
            @complexity = (complexity || 0.5).to_f.clamp(0.0, 1.0).round(10)
            @stability  = (stability || 0.7).to_f.clamp(0.0, 1.0).round(10)
            @facet_ids  = []
            @created_at = Time.now.utc
          end

          def add_facet(facet_id)
            return :already_present if @facet_ids.include?(facet_id)

            @facet_ids << facet_id
            recalculate_complexity!
            :added
          end

          def remove_facet(facet_id)
            return :not_found unless @facet_ids.include?(facet_id)

            @facet_ids.delete(facet_id)
            recalculate_complexity!
            :removed
          end

          def rotate_all!(degrees: Constants::ROTATION_STEP * 360)
            @stability = (@stability - (degrees.abs / 3600.0)).clamp(0.0, 1.0).round(10)
            degrees
          end

          def stabilize!(rate: 0.1)
            @stability = (@stability + rate.abs).clamp(0.0, 1.0).round(10)
          end

          def destabilize!(rate: 0.05)
            @stability = (@stability - rate.abs).clamp(0.0, 1.0).round(10)
          end

          def fractal?
            @complexity >= 0.8
          end

          def minimal?
            @complexity < 0.2
          end

          def stable?
            @stability >= 0.7
          end

          def chaotic?
            @stability < 0.3
          end

          def complexity_label
            Constants.label_for(Constants::COMPLEXITY_LABELS, @complexity)
          end

          def facet_count
            @facet_ids.size
          end

          def to_h
            {
              id:               @id,
              symmetry:         @symmetry,
              complexity:       @complexity,
              stability:        @stability,
              complexity_label: complexity_label,
              facet_count:      facet_count,
              fractal:          fractal?,
              chaotic:          chaotic?,
              created_at:       @created_at
            }
          end

          private

          def validate_symmetry!(val)
            return if Constants::SYMMETRY_TYPES.include?(val.to_sym)

            raise ArgumentError,
                  "unknown symmetry: #{val.inspect}; " \
                  "must be one of #{Constants::SYMMETRY_TYPES.inspect}"
          end

          def recalculate_complexity!
            base = (@facet_ids.size / 20.0).clamp(0.0, 1.0)
            @complexity = base.round(10)
          end
        end
      end
    end
  end
end
