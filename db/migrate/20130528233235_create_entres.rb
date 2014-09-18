class CreateEntres < ActiveRecord::Migration
  def change
    create_table :entres do |t|
      t.string :name
      t.string :url
      t.string :category
      t.string :subcategory
      t.string :year_business_began
      t.string :year_opportunity_offered
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone
      t.string :employees
      t.string :licences
      t.string :type_of_oportunity
      t.string :where_seeking_associates
      t.string :start_up_costs

    end
  end
end
