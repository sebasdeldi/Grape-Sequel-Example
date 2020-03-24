module Controllers
  module V1
    # Reservations related endpoints
    class ReservationsController < Grape::API
      version 'v1', using: :path
      resources :reservations do
        namespace '/movie' do
          params do
            requires :movie_id, type: Integer
            requires :date, type: Date
          end
          route_param :movie_id do
            post do
              result = CreateReservation.call(params: declared(params))
              return result.reservation if result.success?

              status(400)
              { error: result.error }
            end
          end
        end

        params do
          optional :start_date, type: Date
          optional :finish_date, type: Date
        end
        get do
          result = ListReservations.call(params: declared(params))
          return result.reservations if result.success?

          status(400)
          { error: result.error }
        end
      end
    end
  end
end
