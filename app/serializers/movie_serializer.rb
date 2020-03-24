# Serializers for Movie model
class MovieSerializer
  class << self
    def serialize_movie(movie)
      movie.to_hash.merge(
        presentations: movie.presentations.map { |p| p.to_hash.except(:movie_id) }
      )
    end
  end
end
