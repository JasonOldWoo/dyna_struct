require 'spec_helper'

describe DynaStruct::Modifiable::Reader do
  describe '.new' do
    include_examples 'DynaStruct::Reader.new'
  end
  include_examples 'Modifiable'
end