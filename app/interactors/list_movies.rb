# Lists movies, if no weekday is provided returns all the movies
class ListMovies
  include Interactor

  delegate :week_day, to: :context

  VALID_WEEK_DAYS = %w[monday tuesday wednesday thursday friday saturday sunday].freeze

  def call
    if week_day.present?
      unless VALID_WEEK_DAYS.include? week_day
        context.fail!(error: I18n.t('presentations.errors.invalid_week_day'))
      end
      context.movies = movies_by_week_day
    else
      context.movies = unfiltered_movies
    end
  end

  private

  def unfiltered_movies
    Movie.all.map { |movie| MovieSerializer.serialize_movie movie }
  end

  def movies_by_week_day
    Movie.where(presentations: Presentation.where(week_day: week_day)).all
         .map { |movie| MovieSerializer.serialize_movie_by_week_day movie, week_day }
  end
end
