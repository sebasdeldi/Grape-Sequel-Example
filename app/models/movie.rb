# frozen_string_literal: true

# Model for the 'movies' db table
class Movie < Sequel::Model
  plugin :validation_helpers
  plugin :nested_attributes
  one_to_many :presentations
  nested_attributes :presentations

  def validate
    super
    validates_presence %i[name description image_url],
                       message: I18n.t('general.errors.required')

    return if image_url.blank?

    validates_format RegexConstants.url_format, :image_url,
                     message: I18n.t('general.errors.invalid_format')
  end
end
