module DynaStruct
  class Full
    def initialize(args=nil)
      args.each_pair do |k, v|
        instance_variable_set("@#{k}", v)
        add_attribute(k)
      end if args.kind_of?(Hash)
    end

    def [](name)
      instance_variable_get("@#{name}")
    end

    def []=(name, value)
      instance_variable_set("@#{name}", value)
      add_attribute(name)
      value
    end

    def to_h
      instance_variables.inject({}) do |result, var|
        result.merge var.to_s[1..-1].to_sym => instance_variable_get(var)
      end
    end
    alias_method :to_hash, :to_h

    def delete_field(name)
      if respond_to?(name)
        remove_singleton_method(name, "#{name}=")
        remove_instance_variable("@#{name}")
      end
    end

    def method_missing(method_id, *args)
      method_name = method_id.id2name
      len = args.length
      if method_name.chomp!(?=)
        if len != 1
          raise ArgumentError, "wrong number of arguments (#{len} for 1)", caller(1)
        end
        self[method_name] = args.first
      elsif method_name.chomp!(??)
        unless len.zero?
          raise ArgumentError, "wrong number of arguments (#{len} for 0)", caller(1)
        end
        !!self[method_name]
      elsif len == 0
        self[method_name]
      else
        super
      end
    end

    private
      def add_attribute(name)
        unless respond_to?(name)
          define_singleton_method("#{name}") { instance_variable_get("@#{name}") }
          define_singleton_method("#{name}=") { |value| instance_variable_set("@#{name}", value) }
        end
        name
      end

      def remove_singleton_method(*method_names)
        singleton_class.send(:remove_method, *method_names)
      end
  end
end