require 'fix/protocol/messages/instrument'
require 'fix/protocol/messages/md_entry'

module Fix
  module Protocol
    module Messages

      #
      # A full market refresh
      #
      class MarketDataIncrementalRefresh < Message

        unordered :body do
          field :md_req_id, tag: 262, required: true
          collection :md_entries, counter_tag: 268, klass: FP::Messages::MdEntry
        end

      end
    end
  end
end

