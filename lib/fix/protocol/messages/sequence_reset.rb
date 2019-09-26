module Fix
  module Protocol
    module Messages

      # 
      # A sequence reset message which allows a peer to not retransmit administrative
      # messages in response to resend request. It also enables one to reset the sequence
      # number to any integer larger than the currently expected sequence number
      #
      class SequenceReset < Message

        field :gap_fill_flag,   tag: 123, type: :yn_bool, default: false
        field :new_seq_no,      tag: 36,  type: :integer, required: true

      end

    end
  end
end
