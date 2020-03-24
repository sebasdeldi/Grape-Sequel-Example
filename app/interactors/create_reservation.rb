# Reservation creation bussiness logic
class CreateReservation
  include Interactor

  delegate :params, to: :context

  def call
    DB.transaction do
      reservation = fetch_reservation
      reservation.valid? ? reservation.save : context.fail!(error: reservation.errors)
      update_presentation_available_places
      context.reservation = ReservationSerializer.serialize_reservation reservation.refresh
    end
  end

  private

  def fetch_reservation
    # This ensures that the code is unique
    reservation_code = Time.now.to_i.to_s + Time.now.usec.to_s

    Reservation.new(
      presentation_id: presentation.id,
      reservation_code: reservation_code
    )
  end

  def presentation
    not_available_for_date_error = I18n.t('presentations.errors.not_available_for_date')
    presentation = movie.presentations.find { |p| p.date == params[:date].to_date }
    context.fail!(error: not_available_for_date_error) if presentation.nil?
    presentation_available?(presentation)
  end

  def update_presentation_available_places
    presentation.update(available_places: presentation.available_places - 1)
  end

  def movie
    movie_not_found_error = I18n.t('movies.errors.not_found')
    movie = Movie.find(id: params[:movie_id])
    context.fail!(error: movie_not_found_error) if movie.nil?
    movie
  end

  def presentation_available?(presentation)
    no_places_error = I18n.t('presentations.errors.presentation_full')
    presentation.available_places.zero? ? context.fail!(error: no_places_error) : presentation
  end
end
