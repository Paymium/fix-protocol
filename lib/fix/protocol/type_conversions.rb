module Fix
  module Protocol

    #
    # Defines helper methods to convert to and from FIX data types
    #
    module TypeConversions

      #
      # Parses a FIX-formatted timestamp into a Time instance, milliseconds are discarded
      #
      # @param str [String] A FIX-formatted timestamp
      # @return [Time] An UTC date and time
      #
      def parse_timestamp(str)
        if m = str.match(/\A([0-9]{4})([0-9]{2})([0-9]{2})-([0-9]{2}):([0-9]{2}):([0-9]{2})(.[0-9]{3})?\Z/)
          elts = m.to_a.map(&:to_i)
          Time.new(elts[1], elts[2], elts[3], elts[4], elts[5], elts[6], 0)
        end
      end

      #
      # Outputs a DateTime object as a FIX-formatted timestamp
      #
      # @param dt [DateTime] An UTC date and time
      # @return [String] A FIX-formatted timestamp
      #
      def dump_timestamp(dt)
        dt.utc.strftime('%Y%m%d-%H:%M:%S')
      end

      #
      # Parses an integer
      #
      # @param str [String] An integer as a string
      # @return [Fixnum] The parsed integer
      #
      def parse_integer(str)
        str && str.to_i
      end

      #
      # Dumps an integer to a string
      #
      # @param i [Fixnum] An integer
      # @return [String] It's string representation
      #
      def dump_integer(i)
        i.to_s
      end

      #
      # Dumps a boolean to a Y/N FIX string
      #
      # @param b [Boolean] A boolean
      # @return [String] 'Y' if the parameter is true, 'N' otherwise
      #
      def dump_yn_bool(b)
        b ? 'Y' : 'N'
      end

      #
      # Parses a string into a boolean value
      #
      # @param str [String] The string to parse
      # @return [Boolean] +true+ if the string is 'Y', +false+ otherwise
      #
      def parse_yn_bool(str)
        !!(str == 'Y')
      end

    end
  end
end
