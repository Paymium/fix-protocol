module Fix
  module Protocol

    #
    # Represents a collection of unordered fields
    #
    class UnorderedPart < MessagePart

      #
      # Parses a full or partial FIX message string into the message part nodes
      #
      # @return [String] The string part that wasn't consumed during the parsing
      #
      def parse(str)

        left_to_parse     = str
        left_before_pass  = nil

        while (left_to_parse != left_before_pass) && !parse_failure

          left_before_pass = left_to_parse

          nodes.each do |node|
            if node.can_parse?(left_to_parse)
              left_to_parse = node.parse(left_to_parse)
              self.parse_failure = node.parse_failure
            end
          end
        end

        left_to_parse
      end

    end
  end
end
