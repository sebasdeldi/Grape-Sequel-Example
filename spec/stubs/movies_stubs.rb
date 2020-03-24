# Stubs for movies specs
class MoviesStubs
  class << self
    def movie_creation_json
      {
        name: 'Star Wars',
        description: 'Best movie ever filmed!',
        image_url: 'https://starwars.com',
        presentations: [
          {
            date: '2019-01-01'
          },
          {
            date: '2020-01-01'
          }
        ]
      }.to_json
    end
  end
end
