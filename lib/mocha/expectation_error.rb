require 'mocha/backtrace_filter'

module Mocha

  # We're doing this because activesupport 3.0 ActiveSupport::TestCase expects Mocha::ExpectationError to extend StandardError
  class ExpectationError < StandardError
    
    def initialize(message = nil, backtrace = [])
      super(message)
      filter = BacktraceFilter.new
      set_backtrace(filter.filtered(backtrace))
    end

  end
  
end
