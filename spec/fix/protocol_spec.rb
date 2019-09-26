require_relative '../spec_helper'

describe Fix::Protocol do

  describe '.alias_namespace!' do
    it 'should already have been called' do
      expect(FP).to be(Fix::Protocol)
    end
  end

  describe '.parse' do
    it 'should fail to parse garbage' do
      parsed = FP.parse('garbage')
      expect(parsed).to be_a_kind_of(FP::ParseFailure)
      expect(parsed.errors).to include("Malformed message <garbage>")
    end
  end

end

