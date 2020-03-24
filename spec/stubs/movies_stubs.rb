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
            date: '2020-03-02'
          },
          {
            date: '2020-04-02'
          }
        ]
      }.to_json
    end
  end
end
