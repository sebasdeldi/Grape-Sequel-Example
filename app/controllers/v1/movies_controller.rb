module Controllers
  module V1
    # Movie creation endpoint => /api/v1/movies
    class MoviesController < Grape::API
      version 'v1', using: :path
      resources :movies do
        params do
          requires :name, type: String
          requires :description, type: String
          requires :image_url, type: String
          requires :presentations, type: Array do
            requires :date, type: Date
          end
        end
        post do
          result = CreateMovie.call(params: declared(params))
          return result.movie if result.success?

          status(400)
          { error: result.errors }
        end

        params do
          optional :week_day, type: String
        end
        get do
          result = ListMovies.call(week_day: declared(params)[:week_day])
          return result.movies if result.success?

          status(400)
          { error: result.error }
        end
      end
    end
  end
end
