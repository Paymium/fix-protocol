require_relative '../../../spec_helper'

describe Fix::Protocol::Messages::MarketDataIncrementalRefresh do

  before do
    @mdir = "8=FIX.4.4\x019=118\x0135=X\x0149=MY_ID\x0156=MY_COUNTERPARY\x0134=45\x0152=20141022-10:41:17\x01262=RQ_46822\x01268=1\x01279=0\x01269=0\x01270=12.85\x0115=EUR\x01271=10.654\x0110=254\x01"
  end

  describe '#dump' do
    it 'should return the same market data snapshot that was parsed' do
      expect(FP.parse(@mdir).dump).to eql(@mdir)
    end
  end

end
