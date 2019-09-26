require 'fix/protocol/messages'

module Fix
  module Protocol
    
    #
    # Maps the FIX message type codes to message classes
    #
    module MessageClassMapping

      # The actual code <-> class mapping
      MAPPING = {
        '0' => :heartbeat,
        'A' => :logon,
        '1' => :test_request,
        '2' => :resend_request,
        '3' => :reject,
        '4' => :sequence_reset,
        '5' => :logout,
        'V' => :market_data_request,
        'W' => :market_data_snapshot,
        'X' => :market_data_incremental_refresh,
        'j' => :business_message_reject
      }

      #
      # Returns the message class associated to a message code
      # 
      # @param msg_type [Integer] The FIX message type code
      # @return [Class] The FIX message class
      #
      def self.get(msg_type)
        Messages.const_get(camelcase(MAPPING[msg_type])) if MAPPING.has_key?(msg_type)
      end

      #
      # Returns the message code associated to a message class
      #
      # @param klass [Class] The FIX message class
      # @return [Integer] The FIX message type code
      #
      def self.reverse_get(klass)
        key = klass.name.split('::').last.gsub(/([a-z\d])([A-Z])/,'\1_\2').downcase.to_sym
        MAPPING.find { |p| p[1] == key }[0]
      end

      #
      # Formats a symbol as a proper class name
      #
      # @param s [Symbol] A name to camelcase
      # @return [Symbol] A camelcased class name
      #
      def self.camelcase(s)
        s.to_s.split(' ').map { |str| str.split('_') }.flatten.map(&:capitalize).join.to_sym
      end

      #
      # Mark all the message classes for autoloading
      #
      MAPPING.values.each do |klass|
        Messages.autoload(camelcase(klass), "fix/protocol/messages/#{klass}")
      end

    end
  end
end
