class Hash
  def slice(*args)
    sliced_value = {}
    args.each do |arg|
      sliced_value[arg] = fetch(arg)
    end

    sliced_value
  end
end
