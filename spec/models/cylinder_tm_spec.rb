describe CylinderTm do

  let(:cylinder_tm) {FactoryBot.build :cylinder_tm }

  it "gets a valid object from FactoryBot" do
    expect(cylinder_tm).to be_valid
  end

  describe "has optional fields:" do
    [:playback_speed, :fragmented, :repaired_break, :cracked, :damaged_core, :out_of_round, :fungus, :efflorescence, :other_contaminants].each do |att|
      specify "#{att}" do
        cylinder_tm.send("#{att}=", nil)
        expect(cylinder_tm).to be_valid
      end
    end
  end

  describe "has select fields, with value lists:" do
    [:size, :material, :groove_pitch, :recording_method].each do |att|
      specify "#{att}" do
        cylinder_tm.send("#{att}=", 'invalid value')
        expect(cylinder_tm).not_to be_valid
      end
    end
  end

  it_behaves_like "includes TechnicalMetadatumModule", FactoryBot.build(:cylinder_tm) 

  describe "#master_copies" do
    it "returns 1" do
      expect(cylinder_tm.master_copies).to eq 1
    end
  end

  describe "manifest export" do
    specify "has desired headers" do
      expect(cylinder_tm.manifest_headers).to eq []
    end
  end

  describe 'digital provenance requirements' do
    specify 'have customized list' do      
      expect(described_class::DIGITAL_PROVENANCE_FILES).to eq ['Digital Master', 'PresInt', 'Prod', 'PresRef', 'IntRef']
    end
  end
end

