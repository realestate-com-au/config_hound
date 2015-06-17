module ConfigHound

  def self.deep_merge_into(h1, h2)
    return h2 unless h1.is_a?(Hash) && h2.is_a?(Hash)
    h1.merge(h2) do |_key, v1, v2|
      deep_merge_into(v1, v2)
    end
  end

end
