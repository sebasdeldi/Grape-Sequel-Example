# Lists reservations, if no date range is provided returns all the reservations
class ListReservations
  include Interactor

  delegate :params, to: :context

  def call
    context.reservations = if params[:start_date].present? && params[:finish_date].present?
                             reservations_in_range
                           else
                             unfiltered_reservations
                           end
  end

  private

  def unfiltered_reservations
    Reservation.all.map { |reservation| ReservationSerializer.serialize_reservation reservation }
  end

  def reservations_in_range
    Reservation.association_join(:presentation) # Solves N+1 Query
               .all
               .select { |r| date_in_range?(r.presentation.date) }
               .map { |reservation| ReservationSerializer.serialize_reservation reservation }
  end

  def date_in_range?(date)
    date >= params[:start_date] && date <= params[:finish_date]
  end
end
