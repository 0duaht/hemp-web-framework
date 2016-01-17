module Hemp
  class Application
    def call(_env)
      [200, {}, ["Hello from Hemp!"]]
    end
  end
end
