# Movie creation bussiness logic
class CreateMovie
  include Interactor

  delegate :params, to: :context

  def call
    movie = movie(params)
    movie.presentations_attributes = presentations(params[:presentations])
    movie.valid? ? movie.save : context.fail!(errors: movie.errors)
    context.movie = MovieSerializer.serialize_movie(movie)
  end

  private

  def presentations(presentations_params)
    presentations_params.map do |presentation|
      week_day = presentation[:date].to_date.strftime('%A').downcase
      presentation.merge(available_places: 10, week_day: week_day)
    end
  end

  def movie(params)
    Movie.new(
      name: params[:name],
      description: params[:description],
      image_url: params[:image_url]
    )
  end
end
