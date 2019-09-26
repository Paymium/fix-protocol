require_relative '../../../spec_helper'

describe Fix::Protocol::Messages::MarketDataSnapshot do

  before do
    @mds = "8=FIX.4.4\x019=121\x0135=W\x0149=MY_ID\x0156=MY_COUNTERPARTY\x0134=85\x0152=20141022-10:53:35\x01262=PAPA-TANGO-PAPA\x0155=EUR/XBT\x01268=1\x01269=1\x01270=412.54\x01271=45\x0110=222\x01"
  end

  describe '#dump' do
    it 'should return the same market data snapshot that was parsed' do
      expect(FP.parse(@mds).dump).to eql(@mds)
    end
  end

end
