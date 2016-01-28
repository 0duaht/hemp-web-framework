module Hemp
  module Orm
    module ClassInstanceVars
      def properties
        self.class.properties
      end

      def internal_props
        self.class.internal_props
      end

      def sql_properties
        self.class.sql_properties
      end

      def table_name
        self.class.table_name
      end
    end
  end
end
