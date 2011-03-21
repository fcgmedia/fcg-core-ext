Object.class_eval do
  def tap
    yield self
    self
  end unless respond_to?(:tap)
end