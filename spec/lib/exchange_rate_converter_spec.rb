# frozen_string_literal: true

require 'rails_helper'

describe ExchangeRateConverter do
  subject(:converter) do
    described_class.new(exchange_rates: rates, base_currency: 'EUR')
  end
  let(:rates) do
    {
      'USD' => 1.1471,
      'AUD' => 1.5789,
      'BRL' => 4.211
    }
  end

  describe '#convert_to' do
    context 'when converting to invalid currency' do
      it 'raises error' do
        expect { converter.convert_to('INVALID') }.to raise_error(ArgumentError)
      end
    end

    context 'when converting to valid currency' do
      let(:converted_to_brl) { converter.convert_to('BRL') }
      let(:expected_rates) do
        {
          'USD' => 0.27241,
          'AUD' => 0.37495,
          'EUR' => 0.23747
        }
      end

      it 'returns new ExchangeRateConverter instance' do
        expect(converted_to_brl).to be_instance_of(described_class)
      end

      it 'converts exchange rates against new base currency' do
        expect(converted_to_brl.exchange_rates).to eq(expected_rates)
      end

      it 'changes base currency' do
        expect(converted_to_brl.base_currency).to eq('BRL')
      end
    end
  end
end