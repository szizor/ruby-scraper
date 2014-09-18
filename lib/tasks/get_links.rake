desc "Fetch product values"

task :fetch_values => :environment do
  require 'nokogiri'
  require 'open-uri'
  DOMAIN = "http://work-at-home.findthebest.com/l/"
  13.upto (378) do |franchise|
    url = "#{DOMAIN}#{franchise.url}"
    record = {:url=>url}
    doc = Nokogiri::HTML(open(url,"User-Agent" => "Ruby/#{RUBY_VERSION}").read, nil, 'utf-8')
    category = "Work At Home"
    record.merge!({:category=>category})
    subcat = doc.css('.bread-wrap:last').text()
    record.merge!({:subcategory=>subcat})
    title = doc.css("h1.fn").text
    record.merge!({:name=>title})

    uno = doc.xpath('//*[@id="overview-features"]/li[2]/text()')
    if uno
      value = doc.xpath('//*[@id="overview-features"]/li[2]/text()').text
      record.merge!({:categories=>value})
    end
    dos = xpath('//*[@id="detail-sections"]/div[1]/div/div/div[2]/table/tbody/tr[1]/td[2]/text()')
    if dos
      value = xpath('//*[@id="detail-sections"]/div[1]/div/div/div[2]/table/tbody/tr[1]/td[2]/text()').text
      record.merge!({:country=>value})
    end
    tres = doc.xpath('//*[@id="detail-sections"]/div[1]/div/div/div[2]/table/tbody/tr[2]/td[2]/text()')
    if tres
      value = doc.xpath('//*[@id="detail-sections"]/div[1]/div/div/div[2]/table/tbody/tr[2]/td[2]/text()').text
      record.merge!({:year=>value})
    end
    cuatro = doc.xpath('//*[@id="detail-sections"]/div[1]/div/div/div[2]/table/tbody/tr[5]/td[2]/text()')
    if cuatro
      value = doc.xpath('//*[@id="detail-sections"]/div[1]/div/div/div[2]/table/tbody/tr[5]/td[2]/text()').text
      record.merge!({:num_distributors=>value})
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
