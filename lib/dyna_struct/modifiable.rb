module DynaStruct
  module Modifiable
    def <<(args)
      add_attributes args if args.kind_of?(Hash)
      self
    end

    def remove(*vars)
      result = vars.map do |var|
        remove_singleton_method(var.to_s) if singleton_method_defined?(var.to_s)
        remove_singleton_method("#{var}=") if singleton_method_defined?("#{var}=")
        remove_instance_variable("@#{var}") if instance_variable_defined?("@#{var}")
      end
      result.length == 1 ? result.first : result
    end

    def empty?
      instance_variables.empty?
    end

    private
      def remove_singleton_method(method_name)
        singleton_class.send(:remove_method, method_name)
      end

      def singleton_method_defined?(method_name)
        singleton_class.send(:method_defined?, method_name)
      end
  end
end