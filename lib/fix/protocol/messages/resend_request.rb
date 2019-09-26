module Fix
  module Protocol
    module Messages

      #
      # A FIX resend request message, see http://www.onixs.biz/fix-dictionary/4.4/msgType_2_2.html
      #
      class ResendRequest < Message

        unordered :body do
          field :begin_seq_no,  tag: 7,  required: true, type: :integer
          field :end_seq_no,    tag: 16, required: true, type: :integer, default: 0
        end

        #
        # Returns the logon-specific errors
        #
        # @return [Array] The error messages
        #
        def errors
          e = []
          e << "EndSeqNo must either be 0 (inifinity) or be >= BeginSeqNo" unless (begin_seq_no && (end_seq_no.zero? || (end_seq_no >= begin_seq_no)))
          [super, e].flatten
        end

      end
    end
  end
end
