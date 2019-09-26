require_relative '../../spec_helper'

describe FP::MessagePart do

  before do
    FP::MessagePart.send(:instance_variable_set, :@structure, nil)
  end

  describe '.structure' do
    it 'should return an empty array' do
      expect(FP::MessagePart.structure).to be_empty
    end
  end

  describe '.field' do
    it 'should add an item in the field structure' do
      FP::MessagePart.field(:test_field, some_option: 'some_value')
      expect(FP::MessagePart.structure).to eql([{ node_type: :field, name: :test_field, some_option: 'some_value' }])
    end

    it 'should define a working getter' do
      FP::MessagePart.field(:some_field, tag: 42, required: true, default: 'life and everything')
      mp = FP::MessagePart.new
      expect(mp.some_field).to eql('life and everything')
    end

    it 'should define a working setter' do
      FP::MessagePart.field(:some_field, tag: 42, required: true, default: 'life and everything')
      mp = FP::MessagePart.new
      mp.some_field = 'thanks for all the fish'
      expect(mp.some_field).to eql('thanks for all the fish')
    end
  end

  describe '#initialize' do
    it 'should initialize the node tree' do

      class TestClass1 < FP::MessagePart; end;
      TestClass1.field(:field1, {})
      TestClass1.field(:field2, {})

      expect_any_instance_of(TestClass1).to receive(:initialize_node).once.with({ node_type: :field, name: :field1 }).and_return(nil)
      expect_any_instance_of(TestClass1).to receive(:initialize_node).once.with({ node_type: :field, name: :field2 }).and_return(nil)
      TestClass1.new
    end
  end

  describe '#initialize_node' do
    it 'should create an empty field node in the node tree' do
      class TestClass2 < FP::MessagePart; end;
      TestClass2.field(:some_field, tag: 42, required: true, default: 'life and everything')
      mp = TestClass2.new

      expect(mp.nodes.count).to         eql(1)
      expect(mp.nodes.first).to         be_an_instance_of(FP::Field)
      expect(mp.nodes.first.name).to    eql(:some_field)
      expect(mp.nodes.first.tag).to     eql(42)
      expect(mp.nodes.first.value).to   eql('life and everything')
    end
  end

  describe '#dump' do
    it 'should recursively dump all nodes' do
      class TestClass3 < FP::MessagePart; end;
      TestClass3.field(:field1, tag: 42, required: true, default: 'foo')
      TestClass3.field(:field2, tag: 43, required: true, default: 'bar')
      mp = TestClass3.new

      expect(mp.dump).to eql("42=foo\x0143=bar\x01")
    end
  end

  describe '#parse' do
    it 'should parse a string properly' do
      class TestClass4 < FP::MessagePart; end;
      TestClass4.field(:field1, tag: 42, required: true, default: 'foo')
      TestClass4.field(:field2, tag: 43, required: true, default: 'bar')
      mp = TestClass4.new

      mp.parse("42=badum\x0143=tsss\x01")
      expect(mp.parse_failure).to be_nil
      expect(mp.field1).to eql('badum')
      expect(mp.field2).to eql('tsss')
    end
  end

  describe '.parse' do
    it 'should instantiate a message part and parse the passed string' do
      class TestClass5 < FP::MessagePart; end;
      TestClass5.field(:field1, tag: 42, required: true, default: 'foo')
      TestClass5.field(:field2, tag: 43, required: true, default: 'bar')

      mp = TestClass5.parse("42=badum\x0143=tsss\x01")
      expect(mp.parse_failure).to be_nil
      expect(mp.field1).to eql('badum')
      expect(mp.field2).to eql('tsss')
    end
  end

end


