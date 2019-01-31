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
  let(:exchange_rate) { create(:exchange_rate) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:currency) }
    it { is_expected.to validate_uniqueness_of(:currency).scoped_to(:date) }
    it {
      is_expected.to validate_inclusion_of(:currency)
        .in_array(%w(BRL EUR USD AUD))
    }
    it { is_expected.to validate_length_of(:currency).is_equal_to(3) }
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:rate) }
    it { is_expected.to validate_numericality_of(:rate).is_greater_than(0) }
  end
end
