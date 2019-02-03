namespace :fetch_exchange_rates do
  desc 'Fetch today exchange rates'
  task today: :environment do
    Fetcher.today.save('BRL')
  end

  desc 'Fetch all history exchange rates'
  task all: :environment do
    Fetcher.all.save('BRL')
  end
end