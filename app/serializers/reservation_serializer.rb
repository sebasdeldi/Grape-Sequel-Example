# Serializers for Reservation model
class ReservationSerializer
  class << self
    def serialize_reservation(reservation)
      presentation = reservation.presentation
      movie = presentation.movie
      reservation.to_hash.merge(
        presentation: presentation.to_hash.except(:movie_id).merge(
          movie: movie.to_hash
        )
      ).except(:presentation_id)
    end
  end
end
