class JobTitle < ApplicationRecord
  LEVELS = %w[Junior Mid Senior Staff Principal Executive].freeze

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :level, presence: true, inclusion: { in: LEVELS }
end
