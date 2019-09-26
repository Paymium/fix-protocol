require 'fix/protocol/version'
require 'fix/protocol/message'
require 'fix/protocol/message_class_mapping'
require 'fix/protocol/parse_failure'

#
# Main Fix namespace
#
module Fix

  #
  # Main protocol namespace
  #
  module Protocol

    #
    # Parses a string into a Fix::Protocol::Message instance
    #
    # @param str [String] A FIX message string
    # @return [Fix::Protocol::Message] A +Fix::Protocol::Message+ instance, or a +Fix::Protocol::ParseFailure+ in case of failure
    #
    def self.parse(str)
      errors    = []
      msg_type  = str.match(/^8\=[^\x01]+\x019\=[^\x01]+\x0135\=([^\x01]+)\x01/)

      unless str.match(/^8\=[^\x01]+\x019\=[^\x01]+\x0135\=[^\x01]+\x01.+10\=[^\x01]+\x01/)
        FP::ParseFailure.new("Malformed message <#{str}>")
      else

        klass = MessageClassMapping.get(msg_type[1])

        unless klass
          errors << "Unknown message type <#{msg_type[1]}>"
        end

        # Check message length
        length = str.gsub(/10\=[^\x01]+\x01$/, '').gsub(/^8\=[^\x01]+\x019\=([^\x01]+)\x01/, '').length
        if length != $1.to_i
          errors << "Incorrect body length"
        end

        # Check checksum
        checksum = str.match(/10\=([^\x01]+)\x01/)[1]
        expected = ('%03d' % (str.gsub(/10\=[^\x01]+\x01/, '').bytes.inject(&:+) % 256))
        if checksum != expected
          errors << "Incorrect checksum, expected <#{expected}>, got <#{checksum}>"
        end

        if errors.empty?
          msg = klass.parse(str)

          if msg.valid?
            msg
          else
            FP::ParseFailure.new(msg.errors)
          end
        else
          FP::ParseFailure.new(errors)
        end
      end
    end

    #
    # Alias the +Fix::Protocol+ namespace to +FP+ if possible
    #
    def self.alias_namespace!
      Object.const_set(:FP, Protocol) unless Object.const_defined?(:FP)
    end

  end
end

Fix::Protocol.alias_namespace!

