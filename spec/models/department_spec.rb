require 'rails_helper'

RSpec.describe Department, type: :model do
  describe 'validations' do
    subject { build(:department) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
  end

  describe 'associations' do
    it { should have_many(:employees) }
  end
end
