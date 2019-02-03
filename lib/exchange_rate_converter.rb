# frozen_string_literal: true

class ExchangeRateConverter
  attr_reader :exchange_rates, :base_currency

  def initialize(exchange_rates:, base_currency: 'EUR')
    @exchange_rates = exchange_rates
    @base_currency = base_currency
  end

  def convert_to(new_base_currency)
    validate(new_base_currency)
    rates = prepare_rates(new_base_currency)

    converted_rates = rates.inject({}) do |rates, (currency, rate)|
      converted = (1 / @exchange_rates[new_base_currency]) * rate
      rates[currency] = round(converted)
      rates
    end

    ExchangeRateConverter.new(
      exchange_rates: converted_rates,
      base_currency: new_base_currency
    )
  end

 private
  def validate(new_base_currency)
    unless @exchange_rates.has_key?(new_base_currency)
      raise ArgumentError.new("Convert to #{new_base_currency} is not possible")
    end
  end

  def prepare_rates(new_base_currency)
    @exchange_rates.merge(base_currency_rate).except(new_base_currency)
  end

  def base_currency_rate
    Hash[base_currency, 1.0]
  end

  def round(val)
    Float(format('%.5g', val))
  end
end