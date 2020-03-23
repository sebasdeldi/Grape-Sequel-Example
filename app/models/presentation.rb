# Model for the 'presentations' db table
class Presentation < Sequel::Model
  plugin :validation_helpers
  many_to_one :movie
  one_to_many :reservations

  def after_initialize
    super
    self.available_places ||= 10
  end

  def validate
    super
    validates_presence %i[date movie],
                       message: I18n.t('general.errors.required')

    validates_operator(:>, -1, :available_places,
                       message: I18n.t('presentations.errors.presentation_full'))

    return if date.blank?

    validates_format RegexConstants.date_format, :date,
                     message: I18n.t('general.errors.invalid_date_format')
  end
end
