require_relative '../../../spec_helper'

describe 'Fix::Protocol::Messages::MarketDataRequest' do

  before do
    @msg = "8=FIX.4.4|9=139|35=V|49=DAVID_SND|56=PYMBTCDEV|34=3|52=20141014-11:24:41|262=X|263=1|264=0|265=1|267=6|269=0|269=1|269=2|269=4|269=5|269=9|146=1|55=EURXBT|10=021|".gsub(/\|/, "\x01")
  end

  describe '#instruments' do
    it 'should return the correct instruments value' do
      msg = FP.parse(@msg)
      expect(msg.instruments.first.symbol).to eql('EURXBT')
    end
  end

  describe '#md_entry_types' do
    it 'should return the correct mapped values' do
      msg = Fix::Protocol.parse(@msg)
      expect(msg.md_entry_types.map { |met| met.md_entry_type }.sort).to eql([:bid, :ask, :trade, :open, :vwap, :close].sort)
    end
  end

  describe '#raw_md_entry_types' do
    it 'should return the correct raw values' do
      msg = Fix::Protocol.parse(@msg)
      expect(msg.md_entry_types.map { |met| met.raw_md_entry_type }).to eql(["0", "1", "2", "4", "5", "9"])
    end

    it 'should correctly set the node value' do
      msg = Fix::Protocol.parse(@msg)
      msg.md_entry_types.each { |mdet| mdet.raw_md_entry_type = '0' }
      expect(msg.md_entry_types.map { |met| met.md_entry_type }).to eql([:bid, :bid, :bid, :bid, :bid, :bid])
    end
  end

  describe '#md_entry_types=' do
    it 'should accept symbols and map them to their numerical values' do
      msg = FP::Messages::MarketDataRequest.new

      msg.md_entry_types.build do |mde|
        mde.md_entry_type = :open
      end

      expect(msg.md_entry_types.map { |met| met.raw_md_entry_type }[0]).to eql(4)
    end
  end

  describe '#dump' do
    it 'should return the same message' do
      expect(FP.parse(@msg).dump).to eql(@msg)
    end
  end

  describe '.parse' do
    it 'should fail to parse a repeating group when the counter is missing' do
      bogus_msg = "8=FIX.4.4|9=133|35=V|49=DAVID_SND|56=PYMBTCDEV|34=3|52=20141014-11:24:41|262=X|263=1|264=0|265=1|269=0|269=1|269=2|269=4|269=5|269=9|146=1|55=EURXBT|10=252|".gsub(/\|/, "\x01")
      parsed = FP.parse(bogus_msg)
      expect(parsed.errors).to include("MdEntryTypes can not be empty")
    end

    it 'should correctly parse a message with fields in a different order' do
      msg = "8=FIX.4.4|9=133|35=V|34=2|49=DUKENUKEM|52=20141103-17:43:13.901|56=PAYMIUM_DEV|146=1|55=EUR/XBT|262=MDRQ-1415036593798|263=1|264=1|265=1|267=1|269=1|10=012|".gsub(/\|/, "\x01")
      expect(FP.parse(msg)).to be_an_instance_of(FP::Messages::MarketDataRequest)
    end
  end

end

