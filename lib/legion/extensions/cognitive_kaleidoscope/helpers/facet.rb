# frozen_string_literal: true

module Legion
  module Extensions
    module CognitiveKaleidoscope
      module Helpers
        class Facet
          attr_reader :id, :facet_type, :domain, :content,
                      :angle, :created_at
          attr_accessor :brilliance, :transparency

          def initialize(facet_type:, domain:, content:,
                         brilliance: nil, transparency: nil, angle: nil)
            validate_facet_type!(facet_type)
            @id           = SecureRandom.uuid
            @facet_type   = facet_type.to_sym
            @domain       = domain.to_sym
            @content      = content.to_s
            @brilliance   = (brilliance || 0.7).to_f.clamp(0.0, 1.0).round(10)
            @transparency = (transparency || 0.5).to_f.clamp(0.0, 1.0).round(10)
            @angle        = (angle || 0.0).to_f.clamp(0.0, 360.0).round(10)
            @created_at   = Time.now.utc
          end

          def rotate!(degrees: Constants::ROTATION_STEP * 360)
            @angle = ((@angle + degrees.abs) % 360.0).round(10)
          end

          def polish!(rate: 0.1)
            @brilliance = (@brilliance + rate.abs).clamp(0.0, 1.0).round(10)
          end

          def tarnish!(rate: Constants::DECAY_RATE)
            @brilliance = (@brilliance - rate.abs).clamp(0.0, 1.0).round(10)
          end

          def dazzling?
            @brilliance >= Constants::BRILLIANCE_THRESHOLD
          end

          def dark?
            @brilliance < 0.2
          end

          def opaque?
            @transparency < 0.2
          end

          def clear?
            @transparency >= 0.8
          end

          def brilliance_label
            Constants.label_for(Constants::BRILLIANCE_LABELS, @brilliance)
          end

          def to_h
            {
              id:               @id,
              facet_type:       @facet_type,
              domain:           @domain,
              content:          @content,
              brilliance:       @brilliance,
              transparency:     @transparency,
              angle:            @angle,
              brilliance_label: brilliance_label,
              dazzling:         dazzling?,
              dark:             dark?,
              created_at:       @created_at
            }
          end

          private

          def validate_facet_type!(val)
            return if Constants::FACET_TYPES.include?(val.to_sym)

            raise ArgumentError,
                  "unknown facet type: #{val.inspect}; " \
                  "must be one of #{Constants::FACET_TYPES.inspect}"
          end
        end
      end
    end
  end
end
