require "facets"

class Object
  def self.const_missing(const_name)
    require const_name.to_s.pathize
    Object.const_get const_name
  rescue LoadError
    return
  end
end
