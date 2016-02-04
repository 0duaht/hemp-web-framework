module Hemp
  module Dependencies
    def self.load_files
      $LOAD_PATH.unshift(File.join(RACK_ROOT, "app", "controllers"))
      $LOAD_PATH.unshift(File.join(RACK_ROOT, "app", "models"))
      Dir["#{RACK_ROOT}/app/controllers/*"].each { |file| load file }
      Dir["#{RACK_ROOT}/app/models/*"].each { |file| load file }
    end
  end
end
