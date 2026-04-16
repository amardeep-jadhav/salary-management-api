require 'rails_helper'

RSpec.describe JobTitle, type: :model do
  describe 'validations' do
    subject { build(:job_title) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:level) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_inclusion_of(:level).in_array(%w[Junior Mid Senior Staff Principal Executive]) }
  end
end
