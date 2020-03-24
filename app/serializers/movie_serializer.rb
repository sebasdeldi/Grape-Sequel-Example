# Serializers for Movie model
class MovieSerializer
  class << self
    def serialize_movie(movie)
      movie.to_hash.merge(
        presentations: movie.presentations.map { |p| p.to_hash.except(:movie_id) }
      )
    end

    def serialize_movie_by_week_day(movie, week_day)
      movie.to_hash.merge(
        presentations: movie.presentations.select { |p| p.week_day == week_day }
          .map { |p| p.to_hash.except(:movie_id) }
      )
    end
  end
end
