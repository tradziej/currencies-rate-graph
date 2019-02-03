# frozen_string_literal: true

class Fetcher
  attr_reader :rates

  def self.today
    new(Fixer.current)
  end

  def self.all
    new(Fixer.historical)
  end

  def initialize(fixer_feed)
    @rates = filter(fixer_feed.to_a)
  end

  def to_h
    grouped_by_date = @rates.group_by{ |rate| rate.delete(:date) }
    grouped_by_date.each_with_object({}) do |(date, rates), hash|
      hash[date] = rates.each_with_object({}) do |rate, h|
        h[rate[:iso_code]] = rate[:rate]
      end
    end
  end

  def save(currency = 'EUR')
    if currency == 'EUR'
      save_default
    else
      save_converted_to(currency)
    end
  end

 private
  def filter(rates)
    rates.select do |rate|
      ExchangeRate::CURRENCIES.include?(rate[:iso_code]) && rate[:date] >= Date.new(2014, 1, 1)
    end
  end

  def save_converted_to(currency)
    self.to_h.each do |date, rates|
      converter = ExchangeRateConverter.new(exchange_rates: rates)
      converter.convert_to(currency).exchange_rates.each do |currency, rate|
        ExchangeRate.create(
          currency: currency,
          rate: rate,
          date: date
        )
      end
    end
  end

  def save_default
    @rates.each do |rate|
      ExchangeRate.create(
        currency: rate[:iso_code],
        rate: rate[:rate],
        date: rate[:date]
      )
    end
  end
end