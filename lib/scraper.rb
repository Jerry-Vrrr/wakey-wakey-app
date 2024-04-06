require 'nokogiri'
require 'open-uri'
require 'set'
require 'capybara'
require 'capybara/dsl'

# Define the method to scrape data
def scrape_data
  include Capybara::DSL

  # Set up Capybara to use the Selenium driver
  Capybara.default_driver = :selenium
  Capybara.enable_aria_label = true

  def split_scraped_data(data)
    data.split("\n").map { |line| "<div>#{line.strip}</div>" }.join("\n")
  end

  # Define helper method to format date
  def formatted_date
    Time.now.strftime('%y%m%d')
  end

  # URL of the page to scrape
  url = "https://www.crossfit.com/#{formatted_date}"
  # Visit the page using Capybara
  visit(url)
  # Find and click the accept cookies button
  find(:xpath, "//button[contains(@class, 'cf-button')][@aria-label='accept cookie policy']").click
  # Wait for the lazy-loaded image to be present on the page
  has_image = page.has_css?('img')

  # Extract data from the specific div
  feat_image = nil
  specific_div = nil
  if has_image
    feat_image = page.find('img')['src']
    specific_div = Nokogiri::HTML(page.html).css('article').first
  else
    puts "Lazy-loaded image not found on the page."
  end

  if specific_div
    # Extract text content from the specific div
    scraped_data = specific_div.text.strip

    # Remove text after "Resources:"
    scraped_data = scraped_data.split("Resources:").first.strip

    # Split scraped data into separate divs
    scraped_data_html = split_scraped_data(scraped_data)

    # Keywords to search for and their corresponding terms to add to the array
    keyword_mappings = {
      'double-unders' => 'Jump-Rope',
      'single-unders' => 'Jump-Rope',
      'jump-rope'=> 'Jump-Rope',
      'snatch' => 'Lifting Shoes',
      'clean' => 'Lifting Shoes',
      'squat' => 'Lifting Shoes',
      'run' => 'Running Shoes',
      'rope climb'  => 'Long Socks',
      'rope-climb'  => 'Long Socks',
      'lunges' => 'Knee Sleeves',
      'lunge' => 'Knee Sleeves'
      # Add more keywords and their corresponding terms as needed
    }

    # Array to store the matched terms
    matched_terms = Set.new

    # Search for keywords and add corresponding terms to the array
    keyword_mappings.each do |keyword, term|
      matched_terms << term if scraped_data.include?(keyword)
    end

    # Return the scraped data
    {
      feat_image: feat_image,
      scraped_data_html: scraped_data_html,
      matched_terms: matched_terms
    }
  else
    puts "Could not find the specific div element."
    nil
  end
end


# include Capybara::DSL

# # Set up Capybara to use the Selenium driver
# Capybara.default_driver = :selenium
# Capybara.enable_aria_label = true



# # Define helper method to split scraped data into separate divs
# def split_scraped_data(data)
#   data.split("\n").map { |line| "<div>#{line.strip}</div>" }.join("\n")
# end

# # Define helper method to format date
# def formatted_date
#   Time.now.strftime('%y%m%d')
# end

# # URL of the page to scrape
# url = "https://www.crossfit.com/#{formatted_date}"
# # Visit the page using Capybara
# visit(url)
# # Find and click the accept cookies button
# find(:xpath, "//button[contains(@class, 'cf-button')][@aria-label='accept cookie policy']").click
# # Wait for the lazy-loaded image to be present on the page
# has_image = page.has_css?('img')

# # Extract data from the specific div
# feat_image = nil
# specific_div = nil
# if has_image
#   feat_image = page.find('img')['src']
#   specific_div = Nokogiri::HTML(page.html).css('article').first
# else
#   puts "Lazy-loaded image not found on the page."
# end

# if specific_div
#   # Extract text content from the specific div
#   scraped_data = specific_div.text.strip

#   # Remove text after "Resources:"
#   scraped_data = scraped_data.split("Resources:").first.strip

#   # Split scraped data into separate divs
#   scraped_data_html = split_scraped_data(scraped_data)

#   # Keywords to search for and their corresponding terms to add to the array
#   keyword_mappings = {
#     'double-unders' => 'Jump-Rope',
#     'single-unders' => 'Jump-Rope',
#     'jump-rope'=> 'Jump-Rope',
#     'snatch' => 'Lifting Shoes',
#     'clean' => 'Lifting Shoes',
#     'squat' => 'Lifting Shoes',
#     'run' => 'Running Shoes',
#     'rope climb'  => 'Long Socks',
#     'rope-climb'  => 'Long Socks',
#     'lunges' => 'Knee Sleeves',
#     'lunge' => 'Knee Sleeves'
#     # Add more keywords and their corresponding terms as needed
#   }

#   # Array to store the matched terms
#   matched_terms = Set.new

#   # Search for keywords and add corresponding terms to the array
#   keyword_mappings.each do |keyword, term|
#     matched_terms << term if scraped_data.include?(keyword)
#   end