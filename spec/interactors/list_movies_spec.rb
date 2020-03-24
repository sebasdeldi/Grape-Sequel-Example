describe ListMovies do
  describe '#call' do
    subject(:list_movies) { described_class.call(week_day: week_day) }

    let(:create_movie) do
      params = JSON.parse(MoviesStubs.movie_creation_json).deep_symbolize_keys
      CreateMovie.call(params: params)
    end

    let(:valid_days) { %w[monday tuesday wednesday thursday friday saturday sunday].freeze }

    before { create_movie }

    context 'when a valid params are provided' do
      let(:week_day) { Movie.first.presentations.first.week_day }

      context 'when records are found' do
        it "lists the movie with only it's matching presentations" do
          only_matching_records = list_movies.movies.all? do |m|
            m[:presentations].all? { |p| p[:week_day] == week_day }
          end
          expect(only_matching_records).to be_truthy
        end
      end

      context 'when records are not found' do
        let(:week_day) do
          matching_day = Movie.first.presentations.first.week_day
          valid_days.find { |day| day != matching_day }
        end

        it 'returns an empty array' do
          expect(list_movies.movies).to be_empty
        end
      end

      it 'the context succeeds' do
        expect(list_movies).to be_a_success
      end

      context 'when no weekday param is provided' do
        let(:week_day) { '' }

        it 'lists all movie records' do
          expect(list_movies.movies.size).to eq(Movie.count)
        end
      end
    end

    context 'when an invalid week day is provided' do
      let(:week_day) { 'blablabla' }

      it 'the context fails' do
        expect(list_movies).to be_a_failure
      end

      it 'returns errors' do
        expect(list_movies.error).not_to be_blank
      end
    end
  end
end
