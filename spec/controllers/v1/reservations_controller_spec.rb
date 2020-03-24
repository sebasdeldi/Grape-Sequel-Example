describe Controllers::V1::ReservationsController do
  include Rack::Test::Methods

  def app
    Controllers::V1::ReservationsController
  end

  context 'POST /api/v1/reservations/movie/:movie_id' do
    subject(:request) do
      post(
        "/api/v1/reservations/movie/#{movie_id}",
        params,
        'CONTENT_TYPE' => 'application/json'
      )
    end

    before { request }

    context 'when creation fails' do
      let(:movie_id) { -1 }
      let(:params) { { date: '' } }

      it 'responds with 400 status' do
        expect(last_response.status).to eq 400
      end

      it 'responds with the validation errors' do
        expect(JSON.parse(last_response.body)['error'].present?).to be_truthy
      end
    end

    context 'when creation success' do
      let(:movie) do
        params = JSON.parse(MoviesStubs.movie_creation_json).deep_symbolize_keys
        CreateMovie.call(params: params).movie
      end
      let(:movie_id) { movie[:id] }
      let(:params) do
        { date: movie[:presentations].first[:date].to_s }.to_json
      end

      it 'responds with 201 status' do
        expect(last_response.status).to eq 201
      end
    end
  end
end
