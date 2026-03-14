# frozen_string_literal: true

module Legion
  module Extensions
    module CognitiveKaleidoscope
      module Helpers
        module Constants
          FACET_TYPES = %i[belief experience emotion memory intuition].freeze

          ROTATION_MODES = %i[slow steady rapid chaotic].freeze

          SYMMETRY_TYPES = %i[bilateral radial rotational asymmetric].freeze

          MAX_FACETS   = 500
          MAX_PATTERNS = 100
          ROTATION_STEP = 0.1
          DECAY_RATE    = 0.02
          BRILLIANCE_THRESHOLD = 0.8

          BRILLIANCE_LABELS = [
            [(0.8..),      :dazzling],
            [(0.6...0.8),  :vivid],
            [(0.4...0.6),  :moderate],
            [(0.2...0.4),  :dim],
            [(..0.2),      :dark]
          ].freeze

          COMPLEXITY_LABELS = [
            [(0.8..),      :fractal],
            [(0.6...0.8),  :intricate],
            [(0.4...0.6),  :balanced],
            [(0.2...0.4),  :simple],
            [(..0.2),      :minimal]
          ].freeze

          def self.label_for(table, value)
            table.each { |range, label| return label if range.cover?(value) }
            table.last.last
          end
        end
      end
    end
  end
end
