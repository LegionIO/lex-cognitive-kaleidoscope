# frozen_string_literal: true

module Legion
  module Extensions
    module CognitiveKaleidoscope
      module Helpers
        class KaleidoscopeEngine
          def initialize
            @facets   = {}
            @patterns = {}
          end

          def create_facet(facet_type:, domain:, content:, brilliance: nil, transparency: nil, angle: nil)
            raise ArgumentError, 'facet limit reached' if @facets.size >= Constants::MAX_FACETS

            f = Facet.new(facet_type: facet_type, domain: domain, content: content,
                          brilliance: brilliance, transparency: transparency, angle: angle)
            @facets[f.id] = f
            f
          end

          def create_pattern(symmetry: :radial, complexity: nil, stability: nil)
            raise ArgumentError, 'pattern limit reached' if @patterns.size >= Constants::MAX_PATTERNS

            p = Pattern.new(symmetry: symmetry, complexity: complexity, stability: stability)
            @patterns[p.id] = p
            p
          end

          def add_facet_to_pattern(facet_id:, pattern_id:)
            fetch_facet(facet_id)
            pattern = fetch_pattern(pattern_id)
            pattern.add_facet(facet_id)
          end

          def rotate_facet(facet_id:, degrees: Constants::ROTATION_STEP * 360)
            facet = fetch_facet(facet_id)
            facet.rotate!(degrees: degrees)
            facet
          end

          def polish_facet(facet_id:, rate: 0.1)
            facet = fetch_facet(facet_id)
            facet.polish!(rate: rate)
            facet
          end

          def rotate_pattern(pattern_id:, degrees: Constants::ROTATION_STEP * 360)
            pattern = fetch_pattern(pattern_id)
            pattern.rotate_all!(degrees: degrees)
            resolve_facets(pattern).each { |f| f.rotate!(degrees: degrees) }
            pattern
          end

          def tarnish_all!
            @facets.each_value { |f| f.tarnish! }
          end

          def facets_by_type
            counts = Constants::FACET_TYPES.to_h { |t| [t, 0] }
            @facets.each_value { |f| counts[f.facet_type] += 1 }
            counts
          end

          def brightest(limit: 5)
            @facets.values.sort_by { |f| -f.brilliance }.first(limit)
          end

          def dimmest(limit: 5)
            @facets.values.sort_by(&:brilliance).first(limit)
          end

          def most_complex_patterns(limit: 5)
            @patterns.values.sort_by { |p| -p.complexity }.first(limit)
          end

          def most_stable_patterns(limit: 5)
            @patterns.values.sort_by { |p| -p.stability }.first(limit)
          end

          def dazzling_facets
            @facets.values.select(&:dazzling?)
          end

          def dark_facets
            @facets.values.select(&:dark?)
          end

          def avg_brilliance
            return 0.0 if @facets.empty?

            (@facets.values.sum(&:brilliance) / @facets.size).round(10)
          end

          def avg_complexity
            return 0.0 if @patterns.empty?

            (@patterns.values.sum(&:complexity) / @patterns.size).round(10)
          end

          def kaleidoscope_report
            {
              total_facets:     @facets.size,
              total_patterns:   @patterns.size,
              by_type:          facets_by_type,
              dazzling_count:   dazzling_facets.size,
              dark_count:       dark_facets.size,
              avg_brilliance:   avg_brilliance,
              avg_complexity:   avg_complexity
            }
          end

          def all_facets
            @facets.values
          end

          def all_patterns
            @patterns.values
          end

          private

          def fetch_facet(id)
            @facets.fetch(id) { raise ArgumentError, "facet not found: #{id}" }
          end

          def fetch_pattern(id)
            @patterns.fetch(id) { raise ArgumentError, "pattern not found: #{id}" }
          end

          def resolve_facets(pattern)
            pattern.facet_ids.filter_map { |fid| @facets[fid] }
          end
        end
      end
    end
  end
end
