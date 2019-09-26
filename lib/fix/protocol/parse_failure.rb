module Fix
  module Protocol

    #
    # Represents a failure to parse a message, the +errors+ collection
    # should contain the specific error messages
    #
    class ParseFailure

      attr_accessor :errors, :message

      def initialize(errs, msg = nil)
        @errors   = [errs].flatten.compact
        @message  = msg
      end

    end
  end
end
