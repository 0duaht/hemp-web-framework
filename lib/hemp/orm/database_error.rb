module Hemp
  module Orm
    class DatabaseError < StandardError
      def initialize(custom_message = "")
        super "Error while creating database. "\
        "#{custom_message}"
      end
    end
  end
end
