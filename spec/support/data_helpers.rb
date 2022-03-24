module DataHelpers
  def load_data(filename)
    File.read(File.join(Rails.root, "spec", "data", filename))
  end
end
