desc "Fetch product values"

task :fetch_values => :environment do
  require 'nokogiri'
  require 'open-uri'
  DOMAIN = "http://work-at-home.findthebest.com/l/"
  352.upto (381) do |franchise|
    url = "#{DOMAIN}#{franchise}"
    record = {:url=>url}
    begin
      file = open(url,"User-Agent" => "Ruby/#{RUBY_VERSION}")
      doc = Nokogiri::HTML(file, nil, 'utf-8')
      #doc = Nokogiri::HTML(open(url,"User-Agent" => "Ruby/#{RUBY_VERSION}").read, nil, 'utf-8')
      category = "Work At Home"
      record.merge!({:category=>category})
      subcat = doc.css('.bread-wrap:last').text()
      record.merge!({:subcategory=>subcat})
      title = doc.css("h1.fn").text
      record.merge!({:name=>title})

      # uno = doc.xpath('//*[@id="reviewcontent"]/div[2]')
      # if uno
      #   value = uno.text
      #   record.merge!({:categories=>value})
      # end
      dos = doc.xpath('//*[@id="detail-sections"]/div[1]/div/div/div[2]/table/tbody/tr[1]/td[2]/text()')
      if dos
        value = dos.text
        record.merge!({:country=>value})
      end
      tres = doc.search("[text()*='Country']").first.parent.next_element
      if tres
        value = tres.children.text.strip
        record.merge!({:year=>value})
      end
      cuatro = doc.css("[data-field=NumberAssociates] td.fdata")
      if cuatro
        value = cuatro.text
        record.merge!({:num_distributors=>value})
      end
      cinco = doc.search("[text()*='Startup Kit Price']").first
      if cinco
        value = cinco.next_element.text
        record.merge!({:price=>value})
      end
      seis = doc.search("[text()*='Single or Multi-Level']").first
      if seis
        value = seis.parent.next_element.text
        record.merge!({:single=>value})
      end
      sleep 5
      Franchise.create(record)
    rescue OpenURI::HTTPError => e
      sleep 5
      puts "Exception: " + e.message
    end
  end

end











task :fetch_values => :environment do
  require 'nokogiri'
  require 'open-uri'
  DOMAIN = "http://www.bethebossnetwork.com/"
  Link.all.each do |franchise|
    url = "#{DOMAIN}#{franchise.url}"
    #record = {:name=>franchise.name, :url=>url}
    doc = Nokogiri::HTML(open(url,"User-Agent" => "Ruby/#{RUBY_VERSION}").read, nil, 'utf-8')
    add = []
    product = doc.css('.detail-directory-column1 p').text
    phone   = doc.css('.detail-directory-column2 p').text
    web     = doc.css('.detail-directory-column3 p').text
    doc.css('.address-container').children.each do |c|
      add << c.text.strip
    end
    add.delete("")
    address = add.join(',')


    franchise.product = product
    franchise.phone = phone
    franchise.web = web
    franchise.address = address
    franchise.save
  end
end

task :fetch_values => :environment do
  require 'nokogiri'
  require 'open-uri'
  DOMAIN = "http://www.entrepreneur.com/"
  url = "http://www.npros.com/company_directory.asp"
  doc = Nokogiri::HTML(open(url).read, nil, 'utf-8')
  doc.css('td > a').each do |item|
    Link.create(:name => "normal", :url=> item.attributes["href"].value)
  end
end


('A'..'Z').each do |page|
  params = {'searchParam' => page, 'sortParam' => 'rating', 'isSearch' => 0, 'sortDIR' => 'DESC'}
  url = URI.parse('http://www.bethebossnetwork.com/search/index')
   resp, data = Net::HTTP.post_form(url, params)
  jason = resp.body
  list = []
  hash = JSON.parse jason
  doc = Nokogiri::HTML(hash['standardHTML'], nil, 'utf-8')
  doc.css('.featured-box').each do |box|
    l =  box.at('.featured-box-headline').children.first.attributes["href"].value
    p =  box.at('.featured-box-setupFee').children.text
    n =  box.at('.featured-box-headline').children.first.children.text
    list << {:url => l, :price => p, :name => n}
  end

  list.each do |link|
    Link.create(link)
  end
end


