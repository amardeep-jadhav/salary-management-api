class CreateEmployees < ActiveRecord::Migration[8.1]
  def change
    create_table :employees, id: :uuid do |t|
      t.string :full_name, null: false
      t.string :email, null: false
      t.string :phone
      t.string :gender
      t.string :country, null: false
      t.string :city
      t.references :department, null: false, foreign_key: true, type: :uuid
      t.references :job_title, null: false, foreign_key: true, type: :uuid
      t.string :employment_type, null: false, default: 'full_time'
      t.decimal :salary, precision: 12, scale: 2, null: false
      t.string :currency, null: false, default: 'USD'
      t.date :hired_on, null: false
      t.date :date_of_birth
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :employees, :email, unique: true
    add_index :employees, :country
    add_index :employees, :city
    add_index :employees, :salary
    add_index :employees, :active
    add_index :employees, :hired_on
    add_index :employees, %i[country job_title_id]
    add_index :employees, %i[active country]
  end
end
