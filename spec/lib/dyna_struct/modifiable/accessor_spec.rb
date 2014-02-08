require 'spec_helper'

describe DynaStruct::Modifiable::Accessor do
  describe '.new' do
    include_examples 'DynaStruct::Accessor.new'
  end
  include_examples 'Modifiable'
end