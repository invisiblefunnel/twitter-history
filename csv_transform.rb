require 'csv'

class CSVTransform
  def initialize(*attributes)
    @attributes = attributes
  end

  def call(user_list)
    user_list.
      map { |user| row_for(user) }. # map to array of attributes
      unshift(headers).             # prepend the header row
      map { |row| row.to_csv }.     # turn each row into csv data
      join                          # join the rows into one blob
  end

  def row_for(user)
    @attributes.map { |attr| user.public_send(attr) }
  end

  def headers
    @attributes.map { |attr| attr.to_s.sub('_', ' ') }
  end
end
