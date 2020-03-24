describe Movie do
  subject(:movie) { Movie.new }

  context "when a field that can't be blank is blank" do
    before do
      movie.valid?
    end

    it 'fails with name error' do
      expect(movie.errors[:name].first).to eq I18n.t('general.errors.required')
    end

    it 'fails with description error' do
      expect(movie.errors[:description].first).to eq I18n.t('general.errors.required')
    end

    it 'fails with image_url error' do
      expect(movie.errors[:image_url].first).to eq I18n.t('general.errors.required')
    end
  end

  context 'when image_url has a non url format' do
    before do
      movie.image_url = Faker::Internet.email
      movie.valid?
    end

    it 'fails with format validation error' do
      expect(movie.errors[:image_url].first).to eq I18n.t('general.errors.invalid_format')
    end
  end

  context 'when all fields are correct' do
    let(:movie) { build(:movie) }

    before do
      movie.save
    end

    it 'creates a movie record' do
      expect(Movie.count).to eq 1
    end
  end
end
