require_relative '../../spec_helper'

require 'fix/protocol/message_class_mapping'

describe 'Fix::Protocol::MessageClassMapping' do

  describe '.get' do
    it 'should return the correct mapping for the 0 message type' do
      expect(Fix::Protocol::MessageClassMapping.get('0')).to be(Fix::Protocol::Messages::Heartbeat)
    end
  end

end
