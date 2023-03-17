# frozen_string_literal: true

# Negate the include matcher
RSpec::Matchers.define_negated_matcher :not_include, :include
