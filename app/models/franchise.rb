class Franchise < ActiveRecord::Base
  # attr_accessible :title, :body
def self.to_csv(options = {})
  CSV.generate(options) do |csv|
    csv << column_names
    all.each do |data_bank|
      csv << data_bank.attributes.values_at(*column_names)
    end
  end
end
end
