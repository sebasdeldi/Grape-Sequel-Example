describe Controllers::V1::MoviesController do
  include Rack::Test::Methods

  def app
    Controllers::V1::MoviesController
  end

  context 'POST /api/v1/movies' do
    subject(:request) { post '/api/v1/movies', params, 'CONTENT_TYPE' => 'application/json' }

    before { request }

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

  context 'GET /api/v1/movies' do
    subject(:request) do
      get "/api/v1/movies?week_day=#{week_day}", 'CONTENT_TYPE' => 'application/json'
    end

    context 'when search fails' do
      before { request }

      let(:week_day) { 'blablabla' }

      it 'responds with 400 status' do
        expect(last_response.status).to eq 400
      end

      it 'responds with the validation errors' do
        expect(JSON.parse(last_response.body)['error'].present?).to be_truthy
      end
    end

    context 'when search succeeds' do
      let(:create_movie) do
        params = JSON.parse(MoviesStubs.movie_creation_json).deep_symbolize_keys
        CreateMovie.call(params: params)
      end

      let(:week_day) { Movie.first.presentations.first.week_day }

      before { create_movie }

      it 'responds with 200 status' do
        request
        expect(last_response.status).to eq 200
      end

      it 'responds with the serialized movies' do
        request
        expected_response = MovieSerializer.serialize_movie_by_week_day(Movie.first, week_day)
                                           .deep_stringify_keys
        expected_response['presentations'].each { |p| p['date'] = p['date'].to_s }
        expect(JSON.parse(last_response.body)).to eq([expected_response])
      end
    end
  end
end
