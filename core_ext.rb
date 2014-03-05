module Enumerable
  # remove sequential duplicates
  def destutter
    each_with_object([]) { |e, result| result.push(e) if e != result[-1] }
  end
end
