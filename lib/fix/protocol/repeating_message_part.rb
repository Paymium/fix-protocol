require 'forwardable'
require 'fix/protocol/message_part'

module Fix
  module Protocol

    #
    # Represents a portion of a FIX message consisting of a similar repeating structure
    # preceded by a counter element
    #
    class RepeatingMessagePart < MessagePart

      extend Forwardable
      def_delegators :nodes, :[], :first, :last, :length, :size, :each, :empty?

      include Enumerable

      attr_accessor :counter_tag, :element_klass

      def initialize(opts = {})
        @counter_tag    = opts[:counter_tag]
        @element_klass  = opts[:klass]
        super
      end

      #
      # Appends a new blank node as the last element of the collection
      #
      def build
        nodes << element_klass.new

        if block_given?
          yield(nodes.last)
        end

        nodes.last
      end

      #
      # Dumps the message fragment as the set of dumped elements preceded by the relevant counter tag
      #
      # @return [String] The part of the initial string that didn't get consumed during the parsing
      #
      def dump
        "#{counter_tag}=#{length}\x01#{super}"
      end

      #
      # Checks whether the start of the given string can be parsed as this particular field
      #
      # @param str [String] The string for which we want to parse the beginning
      # @return [Boolean] Whether the beginning of the string can be parsed for this field
      #
      def can_parse?(str)
        str =~ /^#{counter_tag}\=[^\x01]+\x01/
      end

      #
      # Parses an arbitrary number of nodes according to the found counter tag
      #
      def parse(str)
        if str.match(/^#{counter_tag}\=([^\x01]+)\x01/)
          len = $1.to_i 
          @nodes = []
          len.times { @nodes << element_klass.new }
          super(str.gsub(/^#{counter_tag}\=[^\x01]+\x01/, ''))
        end
      end

    end
  end
end
