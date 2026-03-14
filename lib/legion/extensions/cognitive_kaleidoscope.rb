# frozen_string_literal: true

require 'securerandom'

require_relative 'cognitive_kaleidoscope/version'
require_relative 'cognitive_kaleidoscope/helpers/constants'
require_relative 'cognitive_kaleidoscope/helpers/facet'
require_relative 'cognitive_kaleidoscope/helpers/pattern'
require_relative 'cognitive_kaleidoscope/helpers/kaleidoscope_engine'
require_relative 'cognitive_kaleidoscope/runners/cognitive_kaleidoscope'
require_relative 'cognitive_kaleidoscope/client'

module Legion
  module Extensions
    module CognitiveKaleidoscope
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end
