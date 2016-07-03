RSpec.describe Shopr::Product, type: :model do

  it "has a valid factory" do
    expect(build(:yealink_t22p)).to be_valid
  end

  describe "ActiveModel validations" do
    let(:product) { create(:yealink_t22p) }

    it { expect(product).to validate_presence_of(:name) }
    it { expect(product).to validate_presence_of(:sku) }
    it { expect(product).to validate_numericality_of(:weight) }
    it { expect(product).to validate_numericality_of(:price) }
    it { expect(product).to validate_numericality_of(:cost_price) }
  end

end
