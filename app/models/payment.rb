class Payment < ApplicationRecord
  belongs_to :credit

  validates_presence_of :credit
  validates_presence_of :number
  validates_numericality_of :expected_amount, greater_than: 0
  validates_numericality_of :amount, greater_than: 0, allow_nil: true
  validates_numericality_of :number, greater_than: 0
  validates_uniqueness_of :number, scope: :credit_id
  validates_uniqueness_of :expected_at, scope: :credit_id

  validate :credit_must_dispersed
  validate :credit_must_be_approved_by_hr

  scope :paid, -> { where.not(paid_at: nil) }
  scope :unpaid, -> { where(paid_at: nil) }

  private

  def credit_must_dispersed
    unless credit.status == "dispersed" && credit.dispersed_at.present?
      errors.add(:credit, :must_be_dispersed)
    end
  end

  def credit_must_be_approved_by_hr
    unless credit.hr_status == "approved"
      errors.add(:credit, :must_be_approved_by_hr)
    end
  end
end
