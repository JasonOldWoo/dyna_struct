require 'spec_helper'

describe DynaStruct::Full do
  describe '.new' do
    subject { described_class.new(info) }

    context 'given a hash' do
      context 'with valid info' do
        let(:info) { { a: ?a, b: ?b, ab: 12, a18: nil } }

        it 'should assign instance variables corresponding to the Hash' do
          info.each do |key, value|
            subject.instance_variable_get("@#{key}")
              .should eq value
          end
        end

        it 'should create getter and setter methods' do
          info.each do |key, value|
            should respond_to(key)
            subject.send(key).should eq value
            should respond_to("#{key}=")
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

    context 'given anything besides a hash' do
      it 'should return an empty DynaStruct' do
        [:hi, 0, -1, 5, '', ?a, 'abc', nil, false, true, 1.05, [1,?b,3.0]].each do |arg|
          test = described_class.new(arg)
          test.should be_a(described_class)
          test.instance_variables.should be_empty
        end
      end
    end
  end

  describe '.[]' do
    let(:info) { { a: ?a, b: ?b } }

    context 'given a valid attribute' do
      subject { described_class.new(info)[:a] }

      it 'should return the associated value' do
        should eq ?a
      end
    end

    context 'given an invalid attribute' do
      subject { described_class.new(info)[:c] }

      it 'should return nil' do
        should be_nil
      end
    end

    context 'given an impossible attribute' do
      subject { described_class.new(info)['@99'] }

      it { expect { subject }.to raise_exception(NameError) }
    end
  end

  describe '.[]=' do
    subject { described_class.new(b: 3) }

    it 'should return the value' do
      subject.[]=(:c, 12).should eq 12
    end

    context 'setting a new attribute' do
      before { subject[:a] = 2 }

      it 'should set the instance variable' do
        subject.instance_variable_get(:@a).should eq 2
      end

      it 'should create getter and setter methods' do
        should respond_to(:a)
        subject.a.should eq 2
        should respond_to(:a=)
      end
    end

    context 'attribute already exists' do
      before { subject[:b] = 5 }

      it 'should override the value' do
        subject.instance_variable_get(:@b).should eq 5
      end

      it 'should not break getters or setters' do
        should respond_to(:b)
        subject.b.should eq 5
        should respond_to(:b=)
      end
    end

    context 'setting an impossible attribute' do
      subject { described_class.new['@99'] = 12 }

      it { expect { subject }.to raise_exception(NameError) }
    end
  end

  describe '.to_h' do
    subject { described_class.new(info) }
    let(:info) { { a: ?a, b: ?b, ab: 12, a18: nil } }

    it 'should return the hash of instance variables and values' do
      subject.to_h.should eq info
    end

    it 'should use symbols as keys' do
      subject.to_h.keys.each do |key|
        key.should be_a(Symbol)
      end
    end

    it 'should return the variable names without the @' do
      subject.to_h.keys.each do |key|
        key.to_s[0].should_not eq(?@)
      end
    end
  end

  describe '.delete_field' do
    subject { described_class.new(info) }
    let(:info) { { a: ?a, b: ?b, ab: 12, a18: nil } }

    context 'field exists' do
      it 'should remove the getter and setter methods' do
        subject.delete_field(:a)
        should_not respond_to :a
        should_not respond_to :a=
      end

      it 'should remove the instance variable' do
        subject.delete_field(:a)
        subject.instance_variable_get(:@a).should be_nil
      end

      it 'should return the value of the deleted variable' do
        subject.delete_field(:a).should eq info[:a]
      end
    end

    context 'field does not exist' do
      it 'should not raise error' do
        expect { subject.delete_field(:charlie) }.not_to raise_exception
      end

      it 'should return nil' do
        subject.delete_field(:charlie).should be_nil
      end
    end
  end

  describe '.method_missing' do
    subject { described_class.new(info) }
    let(:info) { { a: ?a, b: ?b, ab: 12, a18: nil } }

    context 'given method ending in =' do
      context 'given more than 1 argument' do
        it 'should raise an argument error' do
          expect { subject.send('beta=', 19, 3) }.to raise_exception(ArgumentError)
        end
      end

      context 'given no arguments' do
        it 'should raise an argument error' do
          expect { subject.send('beta=') }.to raise_exception(ArgumentError)
        end
      end

      context 'given a single argument' do
        it 'should set the instance variable' do
          subject.beta = 19
          subject.instance_variable_get(:@beta).should eq 19
        end

        it 'should create getter and setter methods' do
          subject.beta = 19
          should respond_to(:beta)
          subject.beta.should eq 19
          should respond_to(:beta=)
        end

        it 'should return the value' do
          subject.send('beta=', 19).should eq 19
        end
      end
    end

    context 'given a method ending in ?' do
      context 'given an argument' do
        it { expect { subject.beta?(12) }.to raise_exception(ArgumentError) }
      end

      context 'not given an argument' do
        it 'should return the boolean value of the attribute' do
          subject.beta?.should be_false
          subject.a?.should be_true
        end
      end
    end

    context 'given a method not ending in = or ?' do
      context 'given no arguments' do
        it 'should return nil' do
          subject.hello.should be_nil
        end
      end

      context 'given an argument' do
        it { expect { subject.alpha(2) }.to raise_exception(NoMethodError) }
      end
    end
  end
end