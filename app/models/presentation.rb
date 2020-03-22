# Model for the 'presentations' db table
class Presentation < Sequel::Model
  many_to_one :movie
  one_to_many :reservations
end
