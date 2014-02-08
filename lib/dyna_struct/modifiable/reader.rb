module DynaStruct
  module Modifiable
    class Reader < DynaStruct::Reader
      include Modifiable
    end
  end
end