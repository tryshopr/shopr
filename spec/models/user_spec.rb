RSpec.describe Shopr::User, type: :model do

  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  describe "ActiveModel validations" do
    let(:user) { create(:user) }

    it { expect(user).to validate_presence_of(:first_name) }
    it { expect(user).to validate_presence_of(:last_name) }
  end

end
