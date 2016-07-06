# encoding: utf-8
# frozen_string_literal: true

module MobileProvision
  # This module holds the MobileProvision version information.
  module Version
    STRING = '1.1.1'

    module_function

    def version(*_args)
      STRING
    end
  end
end