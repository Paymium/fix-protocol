module Fix

  #
  # Namespace for Treetop grammar extensions
  #
  module GrammarExtensions

    #
    # Extends the message component to return the header, body, 
    # message type, and checksum from an AST
    #
    module Message

      #
      # Returns the FIX message header as a fields array
      #
      # @return <Array> The message header fields
      #
      def header
        unless @header
          hdr = elements[0].elements
          last_fields = hdr.pop

          @header = hdr.map do |e|
            [ e.elements[0].text_value.to_i, e.elements[2].text_value ]
          end

          last_fields.elements.inject(@header) do |h, e|
            h << [ e.elements[0].text_value.to_i, e.elements[2].text_value ]
          end
        end

        @header
      end

      #
      # Returns the FIX message body as a fields array
      #
      # @return <Array> The message body fields
      #
      def body
        @fields ||= elements[1].elements.map do |e|
          [ e.elements[0].text_value.to_i, e.elements[2].text_value ]
        end
      end

      #
      # Returns the FIX message type code
      #
      # @return <String> The message type code
      #
      def msg_type
        header.find { |f| f[0] == 35 }[1]
      end
    end
  end
end
