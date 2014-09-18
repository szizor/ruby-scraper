class CreateFranchises < ActiveRecord::Migration
  def change
    create_table :franchises do |t|
      t.string :name
      t.string :url
      t.string :liquid
      t.string :net_worth
      t.string :total_inv
      t.string :incorporated_name
      t.string :industry
      t.string :business_type
      t.string :industry_subsector
      t.string :year_founded
      t.string :franchising_since
      t.string :total_units
      t.string :royalty_type
      t.string :home_office_loc
      t.timestamps
    end
  end
end
