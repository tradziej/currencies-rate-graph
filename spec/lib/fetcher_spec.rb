# frozen_string_literal: true

require 'rails_helper'

describe Fetcher do
  describe '.today' do
    it 'initializes with current exchange rate feed' do
      fixer = class_double('Fixer').
        as_stubbed_const(:transfer_nested_constants => true)

      expect(fixer).to receive(:current)
      expect(described_class).to receive(:new)

      described_class.today
    end
  end

  describe '.all' do
    it 'initializes with historical exchange rate feed' do
      fixer = class_double('Fixer').
        as_stubbed_const(:transfer_nested_constants => true)

      expect(fixer).to receive(:historical)
      expect(described_class).to receive(:new)

      described_class.all
    end
  end

  describe '#save' do
    let(:rates) {
      [{:date=>Date.new(2019,1,30),
          :iso_code=>"USD",
          :rate=>1.1429},
        {:date=>Date.new(2019,1,30),
          :iso_code=>"AUD",
          :rate=>1.5885},
        {:date=>Date.new(2019,1,30),
          :iso_code=>"BRL",
          :rate=>4.2392}]
    }
    it 'creates ExchangeRate objects' do
      allow_any_instance_of(described_class)
        .to receive(:rates).and_return(rates)

      expect{
        described_class.today.save
      }.to change{ ExchangeRate.count }.by(3)
    end
  end
end