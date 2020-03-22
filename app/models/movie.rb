# Model for the 'movies' db table
class Movie < Sequel::Model
  one_to_many :presentations
end
