# frozen_string_literal: true

# Regex expressions used for validation
class RegexConstants
  class << self
    def url_format
      %r{^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$}
    end

    def date_format
      /\d{4}-\d{2}-\d{2}/
    end
  end
end
