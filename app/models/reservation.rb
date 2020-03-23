# Model for the 'reservations' db table
class Reservation < Sequel::Model
  plugin :validation_helpers
  many_to_one :presentation

  def validate
    super
    validates_presence %i[reservation_code presentation],
                       message: I18n.t('general.errors.required')
    validates_unique :reservation_code,
                     message: I18n.t('general.errors.uniqueness')
  end
end
