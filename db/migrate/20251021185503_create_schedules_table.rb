class CreateSchedulesTable < ActiveRecord::Migration[8.0]
  def change
    create_table :schedules do |t|
      t.references :user, null: false, foreign_key: true
      t.references :trainer, null: false, foreign_key: { to_table: :users }

      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false

      t.integer :status, null: false, default: 0
      t.integer :price, null: false
      t.timestamps
    end
  end
end
