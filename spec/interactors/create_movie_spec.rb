describe CreateMovie do
  describe '#call' do
    subject(:create_movie) { described_class.call(params: params) }

    let(:params) do
      JSON.parse(MoviesStubs.movie_creation_json).deep_symbolize_keys
    end

    before { create_movie }

    context 'when all required params are correct' do
      it 'saves the movie record' do
        expect(Movie.count).not_to be_zero
      end

      it "saves it's associated presentations" do
        expect(Presentation.where(movie: Movie.first).all).not_to be_blank
      end

      it 'marks the context as succeeded' do
        expect(create_movie).to be_a_success
      end
    end

    context 'when all required params are not correct' do
      let(:wrong_params) do
        JSON.parse(MoviesStubs.movie_creation_json).deep_symbolize_keys.except(:name)
      end
      let(:create_movie) { described_class.call(params: wrong_params) }

      it "doesn't save the movie record" do
        expect(Movie.count).to be_zero
      end

      it "doesn't save associated presentations" do
        expect(Presentation.count).to be_zero
      end

      it 'marks the context as failed' do
        expect(create_movie).to be_a_failure
      end

      it 'returns errors' do
        expect(create_movie.errors).not_to be_blank
      end
    end
  end
end
