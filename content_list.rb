require 'memoizable'

class ContentList
  include Enumerable, Memoizable

  NEWLINE = "\n"

  def initialize(delimiter = NEWLINE)
    @delimiter = delimiter
    @collection = yield
  end

  def each(&block)
    @collection.each(&block)
  end

  def to_s
    to_a.join(@delimiter) + NEWLINE
  end
  memoize :to_s
end
