class CreateShares < ActiveRecord::Migration[5.0]
  def change
    create_table :shares do |t|
      t.string    :key
      t.string    :value
      t.string    :ip
      t.datetime  :created_at

      t.timestamps
    end
  end
end
