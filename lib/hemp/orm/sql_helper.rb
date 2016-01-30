require "fileutils"

module Hemp
  module Orm
    module SqlHelper
      FileUtils.mkdir_p "db"
      @db = SQLite3::Database.new File.join "db", "development.sqlite3"

      def self.execute(*sql_args)
        @db.execute(*sql_args)
      end
    end
  end
end
