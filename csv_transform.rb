require 'csv'
require 'memoizable'

class CSVTransform
  include Memoizable

  def initialize(*attributes)
    @attributes = attributes
  end

  def call(list)
    headers + list.
      lazy.                       # lazily evaluate the list
      map { |obj| row_for(obj) }. # map to array of attributes
      map { |row| row.to_csv   }. # turn each row into csv data
      force.                      # evaluate the lazy enumerable
      join                        # join the rows into one blob
  end

  def row_for(obj)
    @attributes.map { |attr| obj.public_send(attr) }
  end

  memoize def headers
    @attributes.map { |attr| attr.to_s.gsub('_', ' ') }.to_csv
  end
end
