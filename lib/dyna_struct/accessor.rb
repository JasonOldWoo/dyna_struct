module DynaStruct
  class Accessor < Base
    private
      def add_attributes(args)
        args.each do |k, v|
          instance_variable_set("@#{k}", v)
          define_singleton_method("#{k}") { instance_variable_get("@#{k}") }
          define_singleton_method("#{k}=") { |value| instance_variable_set("@#{k}", value) }
        end
      end
  end
end