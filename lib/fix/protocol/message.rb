require 'fix/protocol/message_part'
require 'fix/protocol/unordered_part'
require 'fix/protocol/repeating_message_part'
require 'fix/protocol/messages/header'

module Fix
  module Protocol

    #
    # Represents an instance of a FIX message
    #
    class Message < MessagePart

      # Default version for when we do not specify anything
      DEFAULT_VERSION = 'FIX.4.4'
      @@expected_version = DEFAULT_VERSION

      #
      # Allows the version tag to be overridden at runtime
      #
      # @param v [String] The version to output and expect in messages
      #
      def self.version=(v)
        @@expected_version = v
      end

      part :header do
        field :version,     tag: 8, required: true, default: @@expected_version
        field :body_length, tag: 9

        part :header_fields, klass: Messages::HeaderFields
      end

      def initialize
        super
        header.msg_type = MessageClassMapping.reverse_get(self.class)
      end

      #
      # Dumps this message as a FIX protocol message, it will automatically
      # calculate the body length and and checksum
      #
      # @return [String] The FIX message
      #
      def dump
        if valid?
          dumped = super
          header.body_length = dumped.gsub(/^8=[^\x01]+\x01/, '').gsub(/^9=[^\x01]+\x01/, '').length
          dumped = super
          "#{dumped}10=#{'%03d' % (dumped.bytes.inject(&:+) % 256)}\x01"
        end
      end

      #
      # Whether this instance is ready to be dumped as a valid FIX message
      #
      # @return [Boolean] Whether there are errors present for this instance
      #
      def valid?
        (errors.nil? || errors.empty?) && parse_failure.nil?
      end

      #
      # Returns the errors relevant to the message header
      #
      # @return [Array<String>] The errors on the message header
      #
      def errors
        if (version == @@expected_version)
          super
        else
          [super, "Unsupported version: <#{version}>, expected <#{@@expected_version}>"].flatten
        end
      end

    end
  end
end
