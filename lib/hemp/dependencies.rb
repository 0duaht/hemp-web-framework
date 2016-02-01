module Hemp
  module Dependencies
    def self.load_files
      Dir["#{RACK_ROOT}/app/controllers/*"].each { |file| load file }
      Dir["#{RACK_ROOT}/app/models/*"].each { |file| load file }
    end
  end
end
