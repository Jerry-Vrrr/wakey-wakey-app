# README

# Wakey Wakey

![Wakey Wakey Logo](https://pbs.twimg.com/profile_images/1758887850060201984/uJ9F3Aad_400x400.jpg)

Wakey Wakey is a Ruby on Rails application that acts as your daily wake-up call, setting you up for your day by providing you with your daily workout, weather information, and a list of equipment you'll need for the workout. The wake-up call itself is an HTML email containing the above information.

## Features

- **Daily Workout**: Scrapes a web page to access the workout data and includes it in the wake-up call email.
- **Weather Information**: Fetches current weather data from an API and includes it in the wake-up call email.
- **Equipment List**: Matches keywords to choose the right equipment for the workout and includes the list in the wake-up call email.

## Technologies Used

- **Ruby on Rails**: Framework for building web applications using Ruby.
- **Nokogiri**: HTML parser and scraper gem for Ruby.
- **Action Mailer**: Gem for sending email from Rails applications.
- **OpenURI**: Allows Ruby programs to access URLs.
- **Capybara**: Web-based automation testing tool for Ruby.
- **SMTP**: Protocol for sending email.
- **HTML/CSS**: Used to format the wake-up call email.

## Setup

To set up the Wakey Wakey application:

1. Clone the repository from [GitHub](https://github.com/your-username/scraper_app).
2. Install the required gems by running `bundle install`.
3. Set up the necessary environment variables for SMTP configuration.
4. Run the Rails server using `rails server`.
5. Access the application in your web browser.

## Usage

1. Set up your email address and other configurations in the application.
2. Run the application daily to receive your wake-up call email.

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Feel free to customize the README further according to your preferences and additional information you'd like to include.
