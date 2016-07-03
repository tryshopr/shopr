RSpec.describe Shopr::Country, type: :model do

  it "has a valid factory" do
    expect(build(:united_kingdom)).to be_valid
  end

  describe "ActiveModel validations" do
    let(:country) { create(:united_kingdom) }

    it { expect(country).to validate_presence_of(:name) }
  end

end
