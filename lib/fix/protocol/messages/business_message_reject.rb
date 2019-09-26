module Fix
  module Protocol
    module Messages

      #
      # A FIX business-level reject message
      #
      class BusinessMessageReject < Message

        #
        # The business reject reason codes
        #
        BUSINESS_REJECT_REASONS = {
          0 => 'Other',
          1 => 'Unkown ID',
          2 => 'Unknown Security',
          3 => 'Unsupported Message Type',
          4 => 'Application not available',
          5 => 'Conditionally Required Field Missing',
          6 => 'Not authorized',
          7 => 'DeliverTo firm not available at this time'
        }

        unordered :body do
          field :ref_seq_num,             tag: 45,  required: true, type: :integer
          field :ref_msg_type,            tag: 372, required: true,                 mapping: FP::MessageClassMapping::MAPPING
          field :business_reject_ref_id,  tag: 379
          field :business_reject_reason,  tag: 380, required: true, type: :integer, mapping: BUSINESS_REJECT_REASONS
          field :text,                    tag: 58
        end

      end
    end
  end
end


