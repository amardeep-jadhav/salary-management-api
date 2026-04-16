class Employee < ApplicationRecord
  EMPLOYMENT_TYPES = %w[full_time part_time contract].freeze

  belongs_to :department
  belongs_to :job_title

  scope :active, -> { where(active: true) }

  after_commit :invalidate_insights_cache

  validates :full_name, presence: true
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :country, presence: true
  validates :salary, presence: true,
                     numericality: { greater_than: 0 }
  validates :currency, presence: true
  validates :hired_on, presence: true
  validates :employment_type, presence: true,
                               inclusion: { in: EMPLOYMENT_TYPES }

  private

  def invalidate_insights_cache
    Rails.cache.delete_matched("insights/*")
  end
end
