class JobTitle < ApplicationRecord
  LEVELS = %w[Junior Mid Senior Staff Principal Executive].freeze

  has_many :employees, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :level, presence: true, inclusion: { in: LEVELS }
end
