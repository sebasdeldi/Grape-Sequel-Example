# Model for the 'reservations' db table
class Reservation < Sequel::Model
  many_to_one :presentation
end
