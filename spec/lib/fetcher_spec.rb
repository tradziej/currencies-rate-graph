# frozen_string_literal: true

require 'rails_helper'

describe Fetcher do
  subject(:fetcher) { described_class  }
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

  describe '.today' do
    it 'initializes with current exchange rate feed' do
      fixer = class_double('Fixer').
        as_stubbed_const(:transfer_nested_constants => true)

      expect(fixer).to receive(:current)
      expect(fetcher).to receive(:new)

      fetcher.today
    end
  end

  describe '.all' do
    it 'initializes with historical exchange rate feed' do
      fixer = class_double('Fixer').
        as_stubbed_const(:transfer_nested_constants => true)

      expect(fixer).to receive(:historical)
      expect(fetcher).to receive(:new)

      fetcher.all
    end
  end

  describe '#to_h' do
    context 'with an empty rates array' do
      let(:rates) { [] }

      it { expect(fetcher.new(rates).to_h).to eq({}) }
    end

    context 'with rates array' do
      let(:expected) do
        Hash[Date.new(2019,1,30), {
          "AUD"=>1.5885, "BRL"=>4.2392, "USD"=>1.1429
        }]
      end
      it { expect(fetcher.new(rates).to_h).to eq(expected) }
    end
  end

  describe '#save' do
    context 'when default save' do
      it 'creates ExchangeRate objects' do
        allow_any_instance_of(fetcher)
          .to receive(:rates).and_return(rates)

        expect{
          fetcher.today.save
        }.to change{ ExchangeRate.count }.by(3)
      end
    end

    context 'when save converted' do
      it 'converts rate' do
        allow_any_instance_of(fetcher)
          .to receive(:rates).and_return(rates)
        expect(ExchangeRateConverter)
          .to receive(:new).at_least(:once).and_call_original

        fetcher.today.save('BRL')
      end

      it 'creates ExchangeRate objects' do
        allow_any_instance_of(fetcher)
          .to receive(:rates).and_return(rates)

        expect{
          fetcher.today.save('BRL')
        }.to change{ ExchangeRate.count }.by(3)
      end
    end
  end
end