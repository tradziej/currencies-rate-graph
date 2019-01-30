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

require 'rails_helper'

RSpec.describe ExchangeRate, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
