class Entre < ActiveRecord::Base
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
Franchise.all.each do |item|
  item.business_type = item.business_type.gsub("Business Type: ","") if item.business_type
  item.industry = item.industry.gsub("Industry: ","") if item.industry
  item.incorporated_name = item.incorporated_name.gsub("Incorporated Name: ","") if item.incorporated_name
  item.industry_subsector = item.industry_subsector.gsub("Industry Subsector: ","") if item.industry_subsector
  item.year_founded = item.year_founded.gsub("Year Founded: ","") if item.year_founded
  item.total_units = item.total_units.gsub("Total Units: ","") if item.total_units
  item.royalty_type = item.royalty_type.gsub("Royalty Type: ","") if item.royalty_type
  item.home_office_loc = item.home_office_loc.gsub("Home Office Location: ","") if item.home_office_loc
  item.save!
end
