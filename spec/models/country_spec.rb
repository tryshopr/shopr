RSpec.describe Shopr::Country, type: :model do

  it "has a valid factory" do
    expect(build(:uk)).to be_valid
  end

  describe "ActiveModel validations" do
    let(:country) { create(:uk) }

    it { expect(country).to validate_presence_of(:name) }
  end

end
