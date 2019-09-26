require_relative '../../spec_helper'

describe Fix::Protocol::Message do

  before do
    @heartbeat = "8=FIX.4.1\u00019=73\u000135=0\u000149=BRKR\u000156=INVMGR\u000134=235\u000152=19980604-07:58:28\u0001112=19980604-07:58:28\u000110=235\u0001"
  end

  describe '#msg_seq_num' do
    it 'should be delegated to the message header' do
      hb = FP::Messages::Heartbeat.new
      expect(hb.header).to receive(:msg_seq_num=).once.with(42).and_call_original
      expect(hb.header).to receive(:msg_seq_num).once.and_call_original
      hb.msg_seq_num = 42
      expect(hb.msg_seq_num).to eql(42)
    end
  end

  describe '.parse' do
    it 'should return a failure when failing to parse a message' do
      msg = "8=FOO.4.2\u00019=73\u000135=XyZ\u000149=BRKR\u000156=INVMGR\u000134=235\u000152=19980604-07:58:28\u0001112=19980604-07:58:28\u000110=235\u0001"
      failure = Fix::Protocol.parse(msg)
      expect(failure).to be_a_kind_of(Fix::Protocol::ParseFailure)
    end

    it 'should return a failure when the version is not expected' do
      msg = "8=FOO.4.2\u00019=73\u000135=0\u000149=BRKR\u000156=INVMGR\u000134=235\u000152=19980604-07:58:28\u0001112=19980604-07:58:28\u000110=233\u0001"
      failure = Fix::Protocol.parse(msg)
      expect(failure).to be_a_kind_of(Fix::Protocol::ParseFailure)
      expect(failure.errors).to include("Unsupported version: <FOO.4.2>, expected <FIX.4.4>")
    end

    it 'should not return a failure when the version is expected' do
      FP::Message.version = 'FOO.4.2'
      msg = "8=FOO.4.2\u00019=73\u000135=0\u000149=BRKR\u000156=INVMGR\u000134=235\u000152=19980604-07:58:28\u0001112=19980604-07:58:28\u000110=233\u0001"
      failure = Fix::Protocol.parse(msg)
      expect(failure).to be_a_kind_of(Fix::Protocol::Message)
      FP::Message.version = 'FIX.4.4'
    end

    it 'should return a failure when the message type is incorrect' do
      msg = "8=FOO.4.2\u00019=73\u000135=ZOULOU\u000149=BRKR\u000156=INVMGR\u000134=235\u000152=19980604-07:58:28\u0001112=19980604-07:58:28\u000110=235\u0001"
      failure = Fix::Protocol.parse(msg)
      expect(failure).to be_a_kind_of(Fix::Protocol::ParseFailure)
      expect(failure.errors).to include("Unknown message type <ZOULOU>")
    end

    it 'should return a failure when the checksum is incorrect' do
      msg = "8=FOO.4.2\u00019=73\u000135=0\u000149=BRKR\u000156=INVMGR\u000134=235\u000152=19980604-07:58:28\u0001112=19980604-07:58:28\u000110=235\u0001"
      failure = Fix::Protocol.parse(msg)
      expect(failure).to be_a_kind_of(Fix::Protocol::ParseFailure)
      expect(failure.errors).to include("Incorrect checksum, expected <233>, got <235>")
    end

    it 'should return a failure when the body length is incorrect' do
      msg = "8=FOO.4.2\u00019=73\u000135=0\u000149=BRKR\u000156=INVMGR\u000134=235\u000152=19980604-07:58:28\u0001112= <additionnal length> 19980604-07:58:28\u000110=235\u0001"
      failure = Fix::Protocol.parse(msg)
      expect(failure).to be_a_kind_of(Fix::Protocol::ParseFailure)
      expect(failure.errors).to include("Incorrect body length")
    end

    it 'should parse a message to its correct class' do
      msg = "8=FIX.4.4\x019=74\x0135=0\x0149=AAAA\x0156=BBB\x0134=2\x0152=20080420-15:16:13\x01112=L.0001.0002.0003.151613\x0110=034\x01"
      expect(Fix::Protocol.parse(msg)).to be_a_kind_of(Fix::Protocol::Messages::Heartbeat)
    end
  end

  context 'when a message has been parsed' do
    before do
      @parsed = FP.parse("8=FIX.4.4\x019=74\x0135=0\x0149=AAAA\x0156=BBB\x0134=2\x0152=20080420-15:16:13\x01112=L.0001.0002.0003.151613\x0110=034\x01")
    end

    describe '#sender_comp_id' do
      it 'should return a value if the tag is present' do
        expect(@parsed.header.sender_comp_id).to eq('AAAA')
      end
    end

    describe '#sending_time' do
      it 'should set the default value if relevant' do
        expect(FP::Messages::Heartbeat.new.header.sending_time).to be_a_kind_of(Time)
      end
    end

    describe '#version' do
      it 'should return the default value if relevant' do
        expect(FP::Messages::Heartbeat.new.header.version).to eql('FIX.4.4')
      end
    end

  end
end

