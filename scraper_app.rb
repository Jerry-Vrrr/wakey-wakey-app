require 'action_mailer'
require 'nokogiri'
require 'open-uri'
require 'set'
require 'capybara'
require 'capybara/dsl'
require_relative 'lib/weather_api_call'
require_relative 'lib/scraper'

# Call the weather fetch call and organize data
weather_fetcher = WeatherApiCall.new
current_weather = weather_fetcher.fetch_weather_info

temperature = current_weather["temperature_2m"]
wind_speed = current_weather["wind_speed_10m"]
weather_info = "Current temperature: #{temperature}°C\nWind speed: #{wind_speed} m/s"

# uncomment below to test the weather api call
# puts "Current temperature: #{temperature}°C"
# puts "Wind speed: #{wind_speed} m/s"

# Call the scraper method
scraped_data = scrape_data

# Access the scraped data
if scraped_data
  feat_image = scraped_data[:feat_image]
  scraped_data_html = scraped_data[:scraped_data_html]
  matched_terms = scraped_data[:matched_terms]

  # Construct email content
  email_content = <<~EMAIL
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <title>Jerry's Daily Wake-up Call</title>
      <style>
        .container {
          max-width: 600px;
          width: 100%;
        }
        .workout-container {
          background-color: #bfd3c1; /* Green background color */
        }
        .equipment-container {
          background-color: #ffe5d4; /* Red background color */
          color: #694f5d;
        }
        .section-background {
          background-color: #efc7c2; /* Light Red background color */
          color: #694f5d;
        }
      </style>
    </head>
    <body style="margin: 0; padding: 0;">
      <center>
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td align="center" valign="top">
              <div class="container">
                <img src="#{feat_image}" width="100%" style="margin: 0; padding: 0; border: none; display: block;" alt="Workout image">
              </div>
            </td>
          </tr>
          <tr>
            <td align="center" valign="top">
              <div class="container workout-container">
                <div style="padding: 20px; color: white; font-size: 34px; font-weight: bold; letter-spacing: 0.30px; font-family: 'Play', sans-serif;">
                  <h2>Wake-Up Call </br> #{DateTime.now.strftime('%A, %B %-d')}</h2>
                </div>
              </div>
            </td>
          </tr>
          <tr>
            <td align="center" valign="top">
              <div class="container equipment-container">
                <div style="padding: 20px; font-size: 36px; color: black; font-family: 'Open Sans', sans-serif;">
                  <h4> Equipment to pack: <br> #{matched_terms.join(', ')}</h4>
                  <h4>Today's Weather for New Orleans, LA: <br> #{weather_info}</h4>
                </div>
              </div>
            </td>
          </tr>
          <tr>
            <td align="center" valign="top">
              <div class="container section-background">
                <div style="padding: 30px; font-size: 18px; color: #47423b; font-family: 'Open Sans', sans-serif;">
                  <h2 class="workout">Today's Workout:</h2>
                  #{scraped_data_html}
                </div>
              </div>
            </td>
            <td style="padding: 40px;"></td>
          </tr>
        </table>
        <div align="center" valign="top">
          <a href="https://jerryvohrer.weebly.com/contact">
            <img align="center" src="https://pbs.twimg.com/profile_images/1758887850060201984/uJ9F3Aad_400x400.jpg" width="15%" style="margin: 0; padding: 0; border: none; display: inline-block;" alt="Jerry Vohrer Logo">
          </a>
        </div>
      </center>
    </body>
    </html>
  EMAIL

# Set up Action Mailer for sending emails
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  address:              'smtp.office365.com',
  port:                 587,
  domain:               'outlook.com',
  user_name:            'wakeywakeyapp@outlook.com',
  password:             'Bilo123!', 
  authentication:       'login',
  enable_starttls_auto: true,
}

  # Send the email using Action Mailer
  ActionMailer::Base.mail(
    from: 'wakeywakeyapp@outlook.com',
    to: 'jerryvohrer@gmail.com',
    subject: "Your Daily Weather, Workout and Equipment List for #{DateTime.now.strftime('%A, %B %-d')}",
    body: email_content,
    content_type: 'text/html; charset=UTF-8'
  ).deliver_now
else
  puts "Could not find the specific div element."
end