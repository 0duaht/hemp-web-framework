module Hemp
  module Orm
    class RecordInterface
      SqlHelper = Hemp::Orm::SqlHelper

      class << self
        attr_accessor :table_name, :properties,
                      :internal_props, :sql_properties

        def to_table(name)
          @table_name = name
          property :id, type: :integer, primary_key: true
        end

        def property(name, options)
          @properties ||= []
          new_property = Property.new(name, options)
          @properties << new_property unless @properties.include? new_property
        end

        def get_properties
          props = @properties.map(&:name)
          props.delete(:id)

          props
        end

        def create_table
          SqlHelper.execute "create table if not exists "\
          "#{@table_name} (#{@properties.join(', ')})"

          construct_sql_properties
          expose_instance_vars
        end

        def construct_sql_properties
          @internal_props = get_properties
          @sql_properties = @internal_props.join(", ")
        end

        def expose_instance_vars
          @properties.map(&:name).each do |name|
            const_get(self.name).class_eval { attr_accessor name.to_sym }
          end
        end

        def set_instance_vars(scope, row)
          @properties.map(&:name).each_with_index do |name, index|
            scope.instance_variable_set "@#{name}", row[index]
          end
        end

        def initialize_model(row)
          model = const_get(name).new
          set_instance_vars(model, row)

          model
        end

        def find(id)
          row = SqlHelper.execute "select * from #{@table_name} "\
          "where id = ?", [id]

          return initialize_model(row.first) unless row.empty?
          nil
        end

        def count
          row = SqlHelper.execute "select count(*) from #{@table_name}"

          row.first
        end

        def all
          rows = SqlHelper.execute "select * from #{@table_name}"
          rows.map { |row| initialize_model row }
        end

        def destroy(id)
          SqlHelper.execute "delete from #{@table_name} "\
          "where id = ?", [id]
        end

        def destroy_all
          SqlHelper.execute "delete from #{@table_name}"
        end
      end
    end
  end
end
