describe Presentation do
  subject(:presentation) { Presentation.new }

  context "when a field that can't be blank is blank" do
    before do
      presentation.valid?
    end

    it 'fails with date error' do
      expect(presentation.errors[:date].first).to eq I18n.t('general.errors.required')
    end

    it 'fails with movie error' do
      expect(presentation.errors[:movie].first).to eq I18n.t('general.errors.required')
    end
  end

  context 'when date has an incorrect format' do
    before do
      presentation.date = Faker::Internet.email
      presentation.valid?
    end

    it 'fails with format validation error' do
      expect(presentation.errors[:date].first).to eq I18n.t('general.errors.invalid_date_format')
    end
  end

  context 'when a presentation is full and another place is tried to be reserved' do
    before do
      presentation.available_places = -1
      presentation.valid?
    end

    it 'fails with presentation already full error' do
      expect(presentation.errors[:available_places].first)
        .to eq I18n.t('presentations.errors.presentation_full')
    end
  end

  context 'when all fields are correct' do
    let(:movie) { build(:movie) }
    let(:presentation) { build(:presentation, movie: movie) }

    before do
      movie.save
      presentation.save
    end

    it 'creates a presentation record' do
      expect(Presentation.count).to eq 1
    end
  end
end
