shared_examples 'DynaStruct.new' do
  def adding_method(args)
    described_class.new args
  end

  include_examples 'add_attributes'
end

shared_examples 'DynaStruct::Reader.new' do
  include_examples 'DynaStruct.new'

  subject { described_class.new info }
  let(:info) { { a: ?a, b: ?b, ab: 12, a18: nil } }

  it 'should create getter methods' do
    info.each do |key, value|
      should respond_to(key)
      subject.send(key).should eq value
    end
  end
end

shared_examples 'DynaStruct::Accessor.new' do
  include_examples 'DynaStruct::Reader.new'

  subject { described_class.new info}
  let(:info) { { a: ?a, b: ?b, ab: 12, a18: nil } }

  it 'should create setter methods' do
    info.each do |key, value|
      should respond_to("#{key}=")
      expect { subject.send("#{key}=", -2) }
        .not_to raise_exception
      subject.send(key).should eq -2
    end
  end
end

shared_examples 'add_attributes' do
  context 'given a Hash' do
    subject { adding_method(info) }

    context 'with valid info' do
      let(:info) { { a: ?a, b: ?b, ab: 12, a18: nil } }

      it 'should assign instance variables corresponding to the Hash' do
        info.each do |key, value|
          subject.instance_variable_get("@#{key}")
            .should eq value
        end
      end
    end

    context 'with invalid keys' do
      let(:info) { { 9 => 2, ?@ => 4 } }

      it 'should raise an exception' do
        expect { subject }.to raise_exception(NameError)
      end
    end
  end

  context 'given anything that is not a Hash' do
    it 'should not change the DynaStruct' do
      [:hi, 0, -1, 5, '', ?a, 'abc', nil, false, true, 1.05, [1,?b,3.0]].each do |arg|
        subject = adding_method(arg)
        subject.should be_a(described_class)
        subject.instance_variables.should eq []
      end
    end
  end
end