desc "Fetch product values"

task :fetch_values => :environment do
  require 'nokogiri'
  require 'open-uri'
  DOMAIN = "http://www.entrepreneur.com"
  Link.all.each do |franchise|
    url = "#{DOMAIN}#{franchise.url}"
    record = {:url=>url}
    doc = Nokogiri::HTML(open(url).read, nil, 'utf-8')
    category = doc.css(".francrumb a")[1].text
    record.merge!({:category=>category})
    if doc.css(".francrumb a")[2]
      subcat = doc.css(".francrumb a")[2].text
      record.merge!({:subcategory=>subcat})
    end
    title = doc.css(".Dtitle > h1").text
    record.merge!({:name=>title})

    uno = doc.at('p:contains("Products & Services:")')
    if uno
      value = uno.children.text.gsub("Products & Services: ", "")
      record.merge!({:products=>value})
    end
    dos = doc.at('p:contains("Number of Locations:")')
    if dos
      value = dos.children.text.gsub("Number of Locations:", "").strip
      record.merge!({:number_locations=>value})
    end
    tres = doc.at('p:contains("Total Investment:")')
    if tres
      value = tres.children.text.gsub("Total Investment:", "").strip
      record.merge!({:total_inv=>value})
    end
    cuatro = doc.at('p:contains("Founded:")')
    if cuatro
      value = cuatro.children.text.gsub("Founded:", "").strip
      record.merge!({:year_founded=>value})
    end
    cinco = doc.at('p:contains("Began Franchising:")')
    if cinco
      value = cinco.children.text.gsub("Began Franchising:", "").strip
      record.merge!({:franchising_since=>value})
    end
    texts = doc.css(".NsectionList > div.cont").css('div:contains("Franchise Fee:")').text

    fee = texts.match("Franchise Fee:(.*?)\t").to_s.gsub("Franchise Fee:","").strip
    fee2 = texts.match("Franchise Fee:(.*)").to_s.gsub("Franchise Fee:","").strip
    record.merge!({:franchise_fee=>fee2}) if fee2.present? && fee2.length < 15
    record.merge!({:franchise_fee=>fee}) if fee.present? && fee.length < 15

    ongoing = texts.match("Agreement:(.*)").to_s.gsub("Agreement:","").strip
    ongoing2 = texts.match("Agreement:(.*?)\t").to_s.gsub("Agreement:","").strip
    record.merge!({:term_of_franchise=>ongoing}) if ongoing.present? && ongoing.length < 20
    record.merge!({:term_of_franchise=>ongoing2}) if ongoing2.present? && ongoing2.length < 20

    royalty = texts.match("Royalty Fee:(.*)").to_s.gsub("Royalty Fee:","").strip
    royalty2 = texts.match("Royalty Fee:(.*?)\t").to_s.gsub("Royalty Fee:","").strip
    record.merge!({:ongoing_royalty_fee=>royalty}) if royalty.present? && royalty.length < 20
    record.merge!({:ongoing_royalty_fee=>royalty2}) if royalty2.present? && royalty2.length < 20

    texts = doc.css(".NsectionList > div.cont").css('h5:contains("Financial")').text
    net = texts.match("Net Worth:(.*?)\t").to_s.gsub("Net Worth:","").strip
    record.merge!({:net_worth=>net}) if net.present?

    liquid = texts.match("Available:(.*)").to_s.gsub("Available:","").strip
    record.merge!({:liquid=>liquid}) if liquid.present?
    Franchise.create(record)
  end
end











task :fetch_values => :environment do
  require 'nokogiri'
  require 'open-uri'
  DOMAIN = "http://www.entrepreneur.com/"
  Link.all.each do |franchise|
    url = "#{DOMAIN}#{franchise.url}"
    record = {:name=>franchise.name, :url=>url}
    doc = Nokogiri::HTML(open(url).read, nil, 'utf-8')
    uno = doc.at('li:contains("Liquid Capital Required: ")')
    if uno
      value = uno.children.text[/\$(.*)/]
      record.merge!({:liquid=>value})
    end
    dos = doc.at('li:contains("Net Worth Required: ")')
    if dos
      value = dos.children.text[/\$(.*)/]
      record.merge!({:net_worth=>value})
    end
    tres = doc.at('li:contains("Total Investment: ")')
    if tres
      value = tres.children.text[/\$(.*)/]
      record.merge!({:total_inv=>value})
    end
    cuatro = doc.at('li:contains("Incorporated Name: ")')
    if cuatro
      value = cuatro.children.text
      record.merge!({:incorporated_name=>value})
    end
    cinco = doc.at('li:contains("Industry: ")')
    if cinco
      value = cinco.children.text
      record.merge!({:industry=>value})
    end
    seis = doc.at('li:contains("Business Type: ")')
    if seis
      value = seis.children.text
      record.merge!({:business_type=>value})
    end
    siete = doc.at('li:contains("Industry Subsector: ")')
    if siete
      value = siete.children.text
      record.merge!({:industry_subsector=>value})
    end
    ocho = doc.at('li:contains("Year Founded: ")')
    if ocho
      value = ocho.children.text
      record.merge!({:year_founded=>value})
    end
    nueve = doc.at('li:contains("Franchising Since: ")')
    if nueve
      value = nueve.children.text[/\:(.*)/].gsub(": ", "")
      record.merge!({:franchising_since=>value})
    end
    diez = doc.at('li:contains("Total Units: ")')
    if diez
      value = diez.children.text
      record.merge!({:total_units=>value})
    end
    once = doc.at('li:contains("Royalty Type: ")')
    if once
      value = once.children.text
      record.merge!({:royalty_type=>value})
    end
    doce = doc.at('li:contains("Home Office Location: ")')
    if doce
      value = doce.children.text
      record.merge!({:home_office_loc=>value})
    end
    Franchise.create(record)
  end
end

task :fetch_values => :environment do
  require 'nokogiri'
  require 'open-uri'
  DOMAIN = "http://www.entrepreneur.com/"
  url = ""
  doc = Nokogiri::HTML(open(url).read, nil, 'utf-8')
  doc.css('td > a.flt').each do |item|
    Link.create(:name => "premium", :url=> item.attributes["href"].value)
  end
  doc.css("td.listings > h5 > a").each do |link|
    Link.create(:name => "normal", :url=> link.attributes["href"].value)
  end
end
