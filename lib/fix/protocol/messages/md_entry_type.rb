require 'fix/protocol/messages/md_entry'

module Fix
  module Protocol
    module Messages

      #
      # A market data entry type component, see http://www.onixs.biz/fix-dictionary/4.4/tagNum_269.html
      #
      class MdEntryType < MessagePart

        field :md_entry_type, tag: 269, required: true, mapping: FP::Messages::MdEntry::MD_ENTRY_TYPES

      end

    end
  end
end
