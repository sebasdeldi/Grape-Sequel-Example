describe CreateReservation do
  describe '#call' do
    subject(:create_reservation) { described_class.call(params: params) }

    let(:params) do
      { movie_id: Movie.first.id, date: Movie.first.presentations.first.date }
    end

    let(:create_movie) do
      params = JSON.parse(MoviesStubs.movie_creation_json).deep_symbolize_keys
      CreateMovie.call(params: params)
    end

    before { create_movie }

    context 'when the presentation exists and has available places' do
      it "saves the reservation record with it's presentation reference" do
        create_reservation
        expect(Presentation.all.map(&:id))
          .to include(Reservation.first.presentation_id)
      end

      it 'subtracts one from the presentation available places' do
        original_places = Movie.first.presentations.first.available_places
        create_reservation
        expect(Reservation.first.presentation.available_places).to eq(original_places - 1)
      end

      it 'marks the context as succeeded' do
        expect(create_reservation).to be_a_success
      end
    end

    context 'when reservation fails' do
      before { create_reservation }

      context 'when provided movie id is not found' do
        let(:params) { { movie_id: -1 } }

        it 'marks the context as failed' do
          expect(create_reservation).to be_a_failure
        end

        it 'returns errors' do
          expect(create_reservation.error).not_to be_blank
        end
      end

      context 'when presentation is full' do
        let(:params) do
          presentation = Presentation.first.update(available_places: 0)
          { presentation_id: presentation.id }
        end

        it 'marks the context as failed' do
          expect(create_reservation).to be_a_failure
        end

        it 'returns errors' do
          expect(create_reservation.error).not_to be_blank
        end
      end
    end
  end
end
