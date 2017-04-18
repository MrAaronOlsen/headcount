class Hash
  def hash_map
    merged = {}
    self.each do |key, value|
      merged.update(yield(key, value))
    end
    merged
  end
end

class Array
  def hash_map
    merged = {}
    self.each do |element|
      merged.update(yield(element))
    end
    merged
  end
end