# encoding: utf-8
# frozen_string_literal: true

module Weaver
  # This module holds the Tepee version information.
  module Version
    STRING = '1.0.0'

    module_function

    def version(*_args)
      STRING
    end
  end
end