require "facets"

module Hemp
  class Object
    def self.const_missing(const_name)
      Object.const_get const_name
    rescue NameError
      require const_name.to_s.pathize
      Object.const_get const_name
    end
  end
end
