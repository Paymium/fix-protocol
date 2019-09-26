module Fix
  module Protocol
    module Messages

      #
      # A FIX session reject message
      #
      class Logout < Message

        field :text, tag: 58

      end
    end
  end
end


