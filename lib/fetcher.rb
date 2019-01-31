# frozen_string_literal: true

class Fetcher
  CURRENCIES = %w(BRL EUR USD AUD)
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

  def save
    @rates.each do |rate|
      ExchangeRate.create(
        currency: rate[:iso_code],
        rate: rate[:rate],
        date: rate[:date]
      )
    end
  end

 private
  def filter(rates)
    rates.select do |rate|
      CURRENCIES.include?(rate[:iso_code]) && rate[:date] >= Date.new(2014, 1, 1)
    end
  end
end