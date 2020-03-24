describe Reservation do
  subject(:reservation) { Reservation.new }

  context "when a field that can't be blank is blank" do
    before do
      reservation.valid?
    end

    it 'fails with presentation error' do
      expect(reservation.errors[:presentation].first)
        .to eq I18n.t('general.errors.required')
    end

    it 'fails with reservation_code error' do
      expect(reservation.errors[:reservation_code].first)
        .to eq I18n.t('general.errors.required')
    end
  end

  context 'when reservation code is already taken' do
    let(:movie) { build(:movie) }
    let(:presentation) { build(:presentation, movie: movie) }
    let(:reservation) { build(:reservation, presentation: presentation) }
    let(:second_reservation) do
      build(
        :reservation,
        reservation_code: reservation.reservation_code,
        presentation: presentation
      )
    end

    before do
      movie.save
      presentation.save
      reservation.save
    end

    it 'fails with already taken error' do
      second_reservation.valid?
      expect(second_reservation.errors[:reservation_code].first)
        .to eq I18n.t('general.errors.uniqueness')
    end
  end

  context 'when all fields are correct' do
    let(:movie) { build(:movie) }
    let(:presentation) { build(:presentation, movie: movie) }
    let(:reservation) { build(:reservation, presentation: presentation) }

    before do
      movie.save
      presentation.save
      reservation.save
    end

    it 'creates a reservation record' do
      expect(Reservation.count).to eq 1
    end
  end
end
