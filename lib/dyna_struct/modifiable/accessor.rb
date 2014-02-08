module DynaStruct
  module Modifiable
    class Accessor < DynaStruct::Accessor
      include Modifiable
    end
  end
end