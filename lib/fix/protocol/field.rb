require 'fix/protocol/type_conversions'

module Fix
  module Protocol

    #
    # A FIX message field
    #
    class Field

      include TypeConversions

      @@attrs = [:tag, :name, :default, :type, :required, :parse_failure, :mapping]
      @@attrs.each { |attr| attr_accessor(attr) }

      def initialize(node)
        @@attrs.each { |attr| node[attr] && send("#{attr}=", node[attr]) }
        self.value ||= (default.is_a?(Proc) ? default.call(self) : default)
      end

      #
      # Returns the field as a message fragment
      #
      # @return [String] A message fragment terminated by the separator byte
      #
      def dump
        @value && "#{tag}=#{@value}\x01"
      end

      #
      # Checks whether the start of the given string can be parsed as this particular field
      #
      # @param str [String] The string for which we want to parse the beginning
      # @return [Boolean] Whether the beginning of the string can be parsed for this field
      #
      def can_parse?(str)
        str.match(/^#{tag}\=[^\x01]+\x01/)
      end

      #
      # Parses the value for this field from the beginning of the string passed as parameter
      # and return the rest of the string. The field value is assigned to the +@value+ instance variable
      #
      # @param str [String] A string starting with the field to parse
      # @return [String] The same string with the field stripped off
      #
      def parse(str)
        if str.match(/^#{tag}\=([^\x01]+)\x01/)
          @value = $1
          str.gsub(/^[^\x01]+\x01/, '')
        else
          str
        end
      end

      #
      # Returns the type-casted value of the field, according to its type or mapping definition
      #
      # @return [Object] The type-casted value
      #
      def value
        to_type(@value)
      end

      #
      # Assigns a typed value to the field, it is cast according to its type or mapping definition
      #
      # @param v [Object] An object of the defined type for this field
      #
      def value=(v)
        @value = from_type(v)
      end

      #
      # Returns the string representing this value as it would appear in a FIX message without
      # any kind of type conversion or mapping
      #
      # @return [String] The raw field value
      #
      def raw_value
        @value
      end

      #
      # Assigns a string directly to the field value without type casting or mapping it
      #
      # @param v [String] The string value to assign
      #
      def raw_value=(v)
        @value = v
      end

      # 
      # Returns the errors for this field, if any
      #
      # @return [Array] The errors for this field
      #
      def errors
        if required && !@value
          "Missing value for <#{name}> field"
        end
      end

      #
      # Performs the actual mapping or type casting by converting an object to a string
      # or a symbol to a mapped string
      #
      # @param obj [Object] The mapping key or object to convert
      # @return [String] The FIX field value
      #
      def from_type(obj)
        if !obj.nil? && type && !mapping
          send("dump_#{type}", obj)
        elsif !obj.nil? && mapping && mapping.has_key?(obj)
          mapping[obj]
        else
          obj
        end
      end

      #
      # Maps a string to an object or a mapped symbol
      #
      # @param str [String] The string to cast or map
      # @return [Object] An object of the defined type or a mapped symbol
      #
      def to_type(str)
        if str && type && !mapping
          send("parse_#{type}", str)
        elsif str && mapping && mapping.values.map(&:to_s).include?(str)
          mapping.find { |k,v| v.to_s == str.to_s }[0]
        else
          str
        end
      end

    end
  end
end
