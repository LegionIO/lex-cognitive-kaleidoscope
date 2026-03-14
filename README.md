# lex-cognitive-kaleidoscope

Cognitive recombination engine for brain-modeled agentic AI in the LegionIO ecosystem.

## What It Does

Models creative cognitive recombination through the metaphor of a kaleidoscope. Facets are individual cognitive fragments (concepts, memories, emotions, perceptions, abstractions) with a brightness level and rotation angle. Patterns group facets into named arrangements with symmetry types. Rotating facets shifts their angular contribution to any patterns they belong to. Polishing increases brightness; passive tarnishing reduces it. Dazzling facets (brightness >= 0.8) are highlighted as highly active fragments. Pattern rotation shifts all member facets simultaneously.

## Usage

```ruby
require 'legion/extensions/cognitive_kaleidoscope'

client = Legion::Extensions::CognitiveKaleidoscope::Client.new

# Create facets
result = client.create_facet(facet_type: :concept, domain: :engineering, content: 'event sourcing', brightness: 0.7)
facet_id = result[:facet_id]

# Create a pattern and add the facet
pattern = client.create_pattern(name: 'distributed_patterns', symmetry: :radial)
client.add_to_pattern(facet_id: facet_id, pattern_id: pattern[:pattern_id])

# Rotate a facet to shift its perspective
client.rotate(facet_id: facet_id)
# => { success: true, before: 0.0, after: 0.1 }

# Polish to increase brightness
client.polish(facet_id: facet_id, amount: 0.2)
# => { success: true, before: 0.7, after: 0.9 }

# List facets
client.list_facets(limit: 20)
# => { success: true, facets: [...], total: 1 }

# Overall status
client.kaleidoscope_status
# => { success: true, report: { facet_count: 1, pattern_count: 1, dazzling: 1, ... } }
```

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
