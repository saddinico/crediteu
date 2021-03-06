class Transaction < ApplicationRecord
  belongs_to :investor
  belongs_to :deal

  validates :participation, presence: true

  validate :check_total_participation

  after_create :check_if_deal_is_closed

  private

  def check_total_participation
    if deal.transactions.pluck(:participation).inject(:+) == nil && participation > deal.amount
      errors.add(:participation, "Desculpe, esse valor excede o valor máximo permitido")
    elsif (deal.transactions.pluck(:participation).inject(:+) || 0) + participation > deal.amount
      errors.add(:participation, "Desculpe, esse valor excede o valor máximo permitido")
    end
  end

  def check_if_deal_is_closed
    if deal.transactions.pluck(:participation).inject(:+) == deal.amount
      deal.update(status: "completed")
    end
  end

end
