module DynaStruct
  module Modifiable
    class Base < DynaStruct::Base
      include Modifiable
    end
  end
end