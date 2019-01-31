# == Schema Information
#
# Table name: exchange_rates
#
#  id         :bigint(8)        not null, primary key
#  currency   :string
#  date       :date
#  rate       :decimal(12, 5)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ExchangeRate < ApplicationRecord
  CURRENCIES = %w(BRL EUR USD AUD)

  validates :currency, presence: true, uniqueness: { scope: :date }
  validates :currency, inclusion: { in: CURRENCIES }, length: { is: 3 }
  validates :date, presence: true
  validates :rate, presence: true, numericality: { greater_than: 0 }
end
