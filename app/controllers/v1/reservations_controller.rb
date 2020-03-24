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
      end
    end
  end
end
