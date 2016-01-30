module Hemp
  module Dependencies
    def self.load_files
      Dir["app/controllers/*"].each { |file| load file }
      Dir["app/models/*"].each { |file| load file }
    end
  end
end
