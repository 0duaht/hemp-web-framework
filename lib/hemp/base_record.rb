require "sqlite3"
require "hemp/orm/property"
require "hemp/orm/sql_helper"
require "hemp/orm/record_interface"
require "hemp/orm/class_instance_vars"

module Hemp
  class BaseRecord < Hemp::Orm::RecordInterface
    include Hemp::Orm::ClassInstanceVars

    def initialize(hash_arg = {})
      self.class.expose_instance_vars
      return super() if hash_arg.empty?
      save_model_attributes hash_arg
    end

    def save_model_attributes(hash_arg)
      row = []
      properties.map do |property|
        row << hash_arg.values_at(property.name)
      end

      self.class.set_instance_vars(self, row.flatten)
    end

    def save
      row = self.class.find id
      return update if row
      SqlHelper.execute get_save_query
      set_id_value
    rescue SQLite3::ConstraintException
      false
    end

    def set_id_value
      id = SqlHelper.execute("select last_insert_rowid() "\
        "from #{table_name}").first.first
      instance_variable_set "@id", id
    end

    def update
      SqlHelper.execute get_update_query
    rescue SQLite3::ConstraintException
      false
    end

    def destroy
      self.class.destroy id
    end

    def get_save_query
      sql_values = stringify_values.join(", ")

      "insert into #{table_name} (#{sql_properties})"\
        " values (#{sql_values})"
    end

    def get_update_query
      sql_update_properties = get_update_values.join(", ")

      "update #{table_name} set #{sql_update_properties}"\
        " where id = #{id}"
    end

    def get_values
      values = []
      internal_props.each do |column|
        values << (instance_variable_get("@#{column}") || "NULL")
      end

      values
    end

    def stringify_values
      get_values.map do |val|
        (val == "NULL") || (val == "") ? "NULL" : %('#{val}')
      end
    end

    def get_update_values
      all_update_properties = []
      stringify_values.each_with_index do |value, index|
        all_update_properties << (internal_props[index].to_s + " = " + value)
      end

      all_update_properties
    end

    def ==(other)
      instance_variables.each do |var|
        instance_variable_get(var) == other.instance_variable_get(var)
      end
    end
  end
end
