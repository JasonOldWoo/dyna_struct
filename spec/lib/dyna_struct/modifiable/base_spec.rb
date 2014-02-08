require 'spec_helper'

describe DynaStruct::Modifiable::Base do
  describe '.new' do
    include_examples 'DynaStruct.new'
  end
  include_examples 'Modifiable'
end