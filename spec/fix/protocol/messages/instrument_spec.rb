require_relative '../../../spec_helper'

describe FP::Messages::Instrument do

  describe '#errors' do
    it 'should report whenever both security ID and ID source are not both filled or both empty' do
      msg = FP::Messages::Instrument.new
      expect(msg.errors).to be_empty
      msg.security_id = 'foo'
      expect(msg.errors).to include("Security ID, and security source must either be both blank, or both must be provided")
      msg.security_id_source = :bloomberg
      expect(msg.errors).to be_empty
    end
  end

end
