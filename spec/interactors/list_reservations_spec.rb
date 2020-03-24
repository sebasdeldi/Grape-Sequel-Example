describe ListReservations do
  describe '#call' do
    subject(:list_reservations) { described_class.call(params: params) }

    let(:params) do
      { start_date: '2030-01-01'.to_date, finish_date: '2010-01-01'.to_date }
    end

    let(:movie) do
      movie_params = JSON.parse(MoviesStubs.movie_creation_json).deep_symbolize_keys
      CreateMovie.call(params: movie_params).movie
    end

    before do
      reservation_params = { movie_id: movie[:id], date: movie[:presentations].first[:date] }
      CreateReservation.call(params: reservation_params)
    end

    context 'when records are not found' do
      it 'returns an empty array' do
        expect(list_reservations.reservations).to be_empty
      end

      it 'the context succeeds' do
        expect(list_reservations).to be_a_success
      end
    end

    context 'when no date range params are provided' do
      let(:params) { {} }

      it 'lists all movie records' do
        expect(list_reservations.reservations.size).to eq(Reservation.count)
      end

      it 'the context succeeds' do
        expect(list_reservations).to be_a_success
      end
    end

    context 'when records are within the dare range' do
      before do
        reservation_params = { movie_id: movie[:id], date: movie[:presentations][1][:date] }
        CreateReservation.call(params: reservation_params)
      end

      let(:date) { movie[:presentations][1][:date] }

      let(:params) do
        { start_date: date, finish_date: date }
      end

      it 'returns the records within the range' do
        expect(list_reservations.reservations.count).to eq(1)
      end

      it 'the context succeeds' do
        expect(list_reservations).to be_a_success
      end
    end
  end
end
