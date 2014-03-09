require 'csv'

class CSVTransform
  def initialize(*attributes)
    @attributes = attributes
  end

  def call(user_list)
    user_list.
      # map to array of attributes
      map { |u| row_for(u) }.
      # prepend the header row
      unshift(headers).
      # turn each row into csv data
      map { |row| row.to_csv }.
      # join the rows into one blob
      join
  end

  def row_for(user)
    @attributes.map { |attr| user.public_send(attr) }
  end

  def headers
    @attributes.map { |attr| attr.to_s.sub('_', ' ') }
  end
end
