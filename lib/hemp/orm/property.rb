module Hemp
  module Orm
    class Property
      attr_reader :name, :options, :type, :primary_key, :nullable
      def initialize(name, options = {})
        @name = name
        @options = options
        parse_options
      end

      def parse_options
        set_default_options
        @options.each_pair do |key, value|
          case key
          when :type
            instance_variable_set("@type", (value == :text ? "varchar" : value))
          when :primary_key, :nullable
            instance_variable_set("@#{key}", value)
          end
        end
      end

      def set_default_options
        @type = "text"
        @primary_key = false
        @nullable = true
      end

      def to_s
        "#{name} #{type}" <<
          (nullable ? "" : " not null") <<
          (primary_key ? " primary key" : "") <<
          (primary_key && type == :integer ? " autoincrement" : "")
      end

      def ==(other)
        name == other.name
      end
    end
  end
end
