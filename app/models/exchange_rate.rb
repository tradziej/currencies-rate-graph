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
end
