require_relative '../../../spec_helper'

describe FP::Messages::ResendRequest do
  describe '#errors' do
    it 'should report an inconsistent EndSeqNo' do
      rr = FP::Messages::ResendRequest.new
      rr.begin_seq_no = 0
      expect(rr.errors).to_not include('EndSeqNo must either be 0 (inifinity) or be >= BeginSeqNo')
      rr.end_seq_no = -1
      expect(rr.errors).to include('EndSeqNo must either be 0 (inifinity) or be >= BeginSeqNo')
    end
  end
end


