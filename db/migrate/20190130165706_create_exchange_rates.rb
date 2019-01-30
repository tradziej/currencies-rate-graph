class CreateExchangeRates < ActiveRecord::Migration[5.2]
  def change
    create_table :exchange_rates do |t|
      t.string :currency
      t.date :date
      t.decimal :rate, precision: 12, scale: 5
      t.index [:currency, :date], unique: true

      t.timestamps
    end
  end
end
