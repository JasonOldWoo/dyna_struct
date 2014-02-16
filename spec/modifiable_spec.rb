shared_examples 'Modifiable' do
  describe '.<<' do
    subject { new_struct << info }
    let(:info) { { hi: 'hello' } }
    let(:new_struct) { described_class.new }
    
    it 'should return self' do
      should be_a(described_class)
      should be(new_struct)
    end

    def adding_method(args)
      described_class.new << args
    end

    include_examples 'add_attributes'
  end

  describe '.empty?' do
    subject { described_class.new }

    it { should respond_to(:empty?) }

    context 'no attributes assigned' do
      it { should be_empty }
    end

    context 'attributes assigned' do
      before(:each) { subject << { hi: 'hello' } }

      it { should_not be_empty }
    end
  end

  describe '.remove' do
    subject { described_class.new info }
    let(:info) { { a: ?a, b: ?b } }

    context 'passed valid attributes' do
      it 'should return the array of deleted values' do
        subject.remove(*info.keys).should eq info.values
      end

      it 'should return just the value if one attribute given' do
        subject.remove(info.keys.first).should eq info.values.first
      end
    end

    context 'passed invalid attributes' do
      it 'should return nil for those attributes' do
        subject.remove(:a, 'boop').should eq [?a, nil]
        subject.remove('boop').should be_nil
      end
    end

    context 'passed nothing' do
      it 'should return an empty array' do
        subject.remove.should eq []
      end
    end
  end
end
