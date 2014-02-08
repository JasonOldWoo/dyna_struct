module DynaStruct
  class Base
    def initialize(args=nil)
      add_attributes(args) if args.kind_of?(Hash)
    end

    private
      def add_attributes(args)
        args.each do |k, v|
          instance_variable_set("@#{k}", v)
        end
      end
  end
end