describe FilmTm do
  let(:film_tm) { FactoryGirl.create :film_tm }
  let(:valid_film_tm) { FactoryGirl.build :film_tm }
  let(:invalid_film_tm) { FactoryGirl.build :film_tm, :invalid }

  describe 'FactoryGirl' do
    it 'provides a valid object' do
      expect(valid_film_tm).to be_valid
    end
    it 'provides an invalid object' do
      expect(invalid_film_tm).not_to be_valid
    end
  end

  it_behaves_like "includes TechnicalMetadatumModule", FactoryGirl.build(:film_tm)

  describe "has validated fields:" do
    [:gauge].each do |field|
      specify "#{field} value in list" do
        valid_film_tm.send(field.to_s + "=", "invalid value")
        expect(valid_film_tm).not_to be_valid
      end
    end
  end

  describe "#master_copies" do
    it "returns 1" do
      expect(film_tm.master_copies).to eq 1
    end
  end

  describe "manifest export" do
    specify "has desired headers" do
      expect(film_tm.manifest_headers).to eq ['Year', 'Gauge', 'Film generation', 'Footage', 'Base', 'Frame rate', 'Color', 'Aspect ratio', 'Anamorphic', 'Sound', 'Sound format type', 'Sound content type', 'Sound field', 'Clean', 'Resolution', 'Color space', 'Workflow', 'On demand', 'Return on original reel', 'Condition - IU', 'Mold', 'Shrinkage', 'AD strip', 'Missing footage', 'Track count', 'Format duration', 'Stock', 'Conservation actions - IU', 'Miscellaneous', 'Return to']
    end
  end

  describe "#preservation_problems" do
    it "returns a blank string" do
      film_tm.dusty = true
      expect(film_tm.preservation_problems).to be_blank
    end
  end

  describe "#preservation problem" do
    it "returns boolean conditions" do
      film_tm.dusty = true
      expect(film_tm.preservation_problem).not_to be_blank
    end
  end

  describe "#rated_conditions" do
    it "returns rated conditions" do
      film_tm.brittle = 1
      film_tm.rusty = 4
      expect(film_tm.rated_conditions).to match /Brittle: 1/i
      expect(film_tm.rated_conditions).to match /,/
      expect(film_tm.rated_conditions).to match /Rusty: 4/i
    end
  end
  describe "#condition_iu" do
    it "returns boolean + rated conditions" do
      film_tm.dusty = true
      film_tm.brittle = 1
      film_tm.rusty = 4
      expect(film_tm.film_condition).to match "#{film_tm.preservation_problem}, #{film_tm.rated_conditions}"
    end
  end

end
