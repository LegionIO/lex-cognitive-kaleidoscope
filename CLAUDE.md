# lex-cognitive-kaleidoscope

**Level 3 Leaf Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-agentic/CLAUDE.md`
- **Gem**: `lex-cognitive-kaleidoscope`

## Purpose

Models cognitive recombination through the metaphor of a kaleidoscope. Facets are individual cognitive fragments (concepts, memories, emotions, perceptions, abstractions) with brightness and a rotation angle. Patterns are groupings of facets that produce emergent arrangements. Rotating a facet shifts its contribution to any patterns it belongs to. Polishing increases brightness. Tarnishing reduces brightness passively over time. Dazzling facets (brightness >= BRILLIANCE_THRESHOLD) are highlighted as highly active fragments.

## Gem Info

| Field | Value |
|---|---|
| Gem name | `lex-cognitive-kaleidoscope` |
| Version | `0.1.0` |
| Namespace | `Legion::Extensions::CognitiveKaleidoscope` |
| Ruby | `>= 3.4` |
| License | MIT |
| GitHub | https://github.com/LegionIO/lex-cognitive-kaleidoscope |

## File Structure

```
lib/legion/extensions/cognitive_kaleidoscope/
  cognitive_kaleidoscope.rb         # Top-level require
  version.rb                        # VERSION = '0.1.0'
  client.rb                         # Client class
  helpers/
    constants.rb                    # Facet types, rotation modes, symmetry types, thresholds, labels
    facet.rb                        # Facet value object
    pattern.rb                      # Pattern value object
    kaleidoscope_engine.rb          # Engine: facets, patterns, rotation, polish, tarnish
  runners/
    cognitive_kaleidoscope.rb       # Runner module (extend self)
```

## Key Constants

| Constant | Value | Meaning |
|---|---|---|
| `FACET_TYPES` | array | `[:concept, :memory, :emotion, :perception, :abstraction]` |
| `ROTATION_MODES` | array | `[:clockwise, :counterclockwise, :oscillating, :fixed]` |
| `SYMMETRY_TYPES` | array | `[:radial, :bilateral, :rotational, :translational, :none]` |
| `MAX_FACETS` | 500 | Facet store cap |
| `MAX_PATTERNS` | 100 | Pattern cap |
| `ROTATION_STEP` | 0.1 | Angle change per rotate call (radians fraction) |
| `DECAY_RATE` | 0.02 | Brightness decrease per tarnish_all! call |
| `BRILLIANCE_THRESHOLD` | 0.8 | Brightness above this = dazzling |
| `BRILLIANCE_LABELS` | array | Labels for brightness levels |
| `COMPLEXITY_LABELS` | array | Labels for pattern complexity (facet count) |

## Helpers

### `Facet`

A single cognitive fragment with brightness and rotation.

- `initialize(facet_type:, domain:, content:, brightness: 0.5, angle: 0.0, facet_id: nil)`
- `rotate!(step)` — increments angle by `ROTATION_STEP`, wraps at 2π
- `polish!(amount)` — increases brightness, cap 1.0
- `tarnish!(rate)` — decreases brightness, floor 0.0
- `dazzling?` — brightness >= `BRILLIANCE_THRESHOLD`
- `dark?` — brightness near 0.0
- `brightness_label`
- `to_h`

### `Pattern`

A named grouping of facets forming an emergent arrangement.

- `initialize(name:, symmetry: :radial, pattern_id: nil)`
- `add_facet(facet_id)` — adds to facet_ids list
- `complexity_label` — based on facet count
- `to_h`

### `KaleidoscopeEngine`

- `create_facet(facet_type:, domain:, content:, brightness: 0.5, angle: 0.0)` — returns `{ created:, facet_id:, facet: }` or capacity error
- `create_pattern(name:, symmetry: :radial)` — returns `{ created:, pattern_id:, pattern: }` or capacity error
- `add_facet_to_pattern(facet_id:, pattern_id:)` — validates both exist; adds facet to pattern
- `rotate_facet(facet_id:, step: ROTATION_STEP)` — returns before/after angle
- `polish_facet(facet_id:, amount: 0.1)` — returns before/after brightness
- `rotate_pattern(pattern_id:, step: ROTATION_STEP)` — rotates all facets in the pattern
- `tarnish_all!(rate: DECAY_RATE)` — decreases brightness of all facets
- `facets_by_type` — grouped hash
- `brightest(limit: 10)`, `dimmest(limit: 10)`
- `dazzling_facets` — all facets where `dazzling? == true`
- `dark_facets` — all facets where `dark? == true`
- `kaleidoscope_report` — full stats

## Runners

**Module**: `Legion::Extensions::CognitiveKaleidoscope::Runners::CognitiveKaleidoscope`

Uses `extend self` pattern.

| Method | Key Args | Returns |
|---|---|---|
| `create_facet` | `facet_type:`, `domain:`, `content:`, `brightness: 0.5`, `angle: 0.0` | `{ success:, facet_id:, facet: }` |
| `create_pattern` | `name:`, `symmetry: :radial` | `{ success:, pattern_id:, pattern: }` |
| `add_to_pattern` | `facet_id:`, `pattern_id:` | `{ success:, pattern: }` |
| `rotate` | `facet_id:`, `step: ROTATION_STEP` | `{ success:, before:, after: }` |
| `polish` | `facet_id:`, `amount: 0.1` | `{ success:, before:, after: }` |
| `list_facets` | `limit: 50` | `{ success:, facets:, total: }` |
| `kaleidoscope_status` | — | `{ success:, report: }` |

Private: `kaleidoscope(engine)` — memoized `KaleidoscopeEngine`. Logs via `log_debug` helper.

## Integration Points

- **`lex-cognitive-integration`**: Integration binds multi-modal signals into coherent representations. The kaleidoscope recombines fragments through rotation and pattern formation — a creative recombination engine complementing integration's binding model.
- **`lex-memory`**: Dazzling facets (high brightness) correspond to highly active, recently reinforced memory traces. `tarnish_all!` parallels memory decay. The kaleidoscope can serve as a creative layer on top of memory retrieval.
- **`lex-dream`**: Dream cycle association walking can produce novel facet groupings that are crystallized as patterns. Dream output as kaleidoscope patterns models the creative recombination that occurs during consolidation.

## Development Notes

- `rotate_pattern` iterates all facets in the pattern and calls `rotate!` on each. Pattern rotation is a batch operation; individual facet rotation is also available.
- `tarnish_all!` affects all facets in the store, not just those assigned to patterns. Unassigned facets tarnish equally.
- `dazzling_facets` returns all facets above `BRILLIANCE_THRESHOLD` (0.8); this is a linear scan. For large facet counts, use `brightest(limit: N)` instead for efficiency.
- In-memory only.

---

**Maintained By**: Matthew Iverson (@Esity)
