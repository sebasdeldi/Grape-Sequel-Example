describe Controllers::V1::MoviesController do
  include Rack::Test::Methods

  def app
    Controllers::V1::MoviesController
  end

  subject(:request) { post '/api/v1/movies', params, 'CONTENT_TYPE' => 'application/json' }
  before { request }

  context 'POST /api/v1/movies' do
    context 'when creation fails' do
      let(:params) { {}.to_json }

      it 'responds with 400 status' do
        expect(last_response.status).to eq 400
      end

      it 'responds with the validation errors' do
        expect(JSON.parse(last_response.body)['error'].present?).to be_truthy
      end
    end

    context 'when creation success' do
      let(:params) { MoviesStubs.movie_creation_json }

      it 'responds with 201 status' do
        expect(last_response.status).to eq 201
      end

      it 'responds with the serialized movie' do
        expected_response = MovieSerializer.serialize_movie(Movie.first)
        expected_response[:presentations].each { |p| p[:date] = p[:date].to_s }
        expect(JSON.parse(last_response.body).deep_symbolize_keys).to eq(expected_response)
      end
    end
  end
end
