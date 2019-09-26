module Fix
  module Protocol
    module Messages

      #
      # An Instrument component, see http://www.onixs.biz/fix-dictionary/4.4/compBlock_Instrument.html
      #
      class Instrument < UnorderedPart

        #
        # The security ID source codes
        #
        SECURITY_ID_SOURCE = {
          '1' => :cusip,
          '2' => :sedol,
          '3' => :quik,
          '4' => :isin,
          '5' => :ric,
          '6' => :iso_currency,
          '7' => :iso_country,
          '8' => :exchange,
          '9' => :consolidated_tape_association,
          'A' => :bloomberg,
          'B' => :wertpapier,
          'C' => :dutch,
          'D' => :valoren,
          'E' => :sicovam,
          'F' => :belgian,
          'G' => :common,
          'H' => :clearing,
          'I' => :isda_fpml,
          'J' => :options_price_reporting_authority
        }

        #
        # The product codes
        #
        PRODUCTS = {
          1 => :agency,
          2 => :commodity,
          3 => :corporate,
          4 => :currency,
          5 => :equity,
          6 => :government,
          7 => :index,
          8 => :loan,
          9 => :moneymarket,
          10 => :mortgage,
          11 => :municipal,
          12 => :other,
          13 => :financing
        }

        field :symbol,              tag: 55
        field :security_id,         tag: 48
        field :security_id_source,  tag: 22,                  mapping: SECURITY_ID_SOURCE
        field :product,             tag: 460, type: :integer, mapping: PRODUCTS
        field :security_desc,       tag: 107

        #
        # Checks whether the start of the given string can be parsed as this particular part
        #
        # @param str [String] The string for which we want to parse the beginning
        # @return [Boolean] Whether the beginning of the string can be parsed for this field
        #
        def can_parse?(str)
          str =~ /(#{self.class.structure.map { |i| i[:tag] }.map(&:to_s).join('|')})=[^\x01]+\x01/
        end

        #
        # Returns an error if security_id and security_source_id are not in the same filled/empty state
        #
        def errors
          e = []

          if !!security_id ^ !!security_id_source
            e << "Security ID, and security source must either be both blank, or both must be provided"
          end

          [super, e].flatten
        end

      end
    end
  end
end
