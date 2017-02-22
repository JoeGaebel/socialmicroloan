require 'highline/import'
require 'stripe'
require 'rest-client'

namespace :test do
  desc "Stripe Connect test"
  task :creds do
    say <<-EOF
    
           <%= color("SocialMicro.Loan Stripe Connect Test", BOLD) %>!
----------------------------------------------------------------
                      Alright, lets GO!
----------------------------------------------------------------
    EOF

    existing_config = Rails.root.join('config/secrets.yml')
    unless File.exists?( existing_config )
      puts 'dead men tell no tales, but those without secrets cant run this app.'
      exit 1
    end

    config = YAML.load_file( existing_config )['development']
    client_id = config['stripe_client_id']
    publishable_key = config['stripe_publishable_key']
    secret_key = config['stripe_secret_key']
    puts "Loaded config/secrets.yml\n\n"

    print "Checking client... "
    client_id_test_url = "https://connect.stripe.com/oauth/authorize?response_type=code&client_id=#{client_id}"
    response = RestClient.get client_id_test_url
    if response.code != 200
      puts "That doesn't appear to be a valid client_id. Please see the README"
      exit 1
    else
      puts "OK"
    end

    # check publishable
    print "Checking publishable... "
    token = Stripe::Token.create( {
      card: { number: '4242424242424242',
        exp_month: 1, exp_year: Date.today.year + 3,
        cvc: '123' }
    }, publishable_key ) rescue nil

    if token.nil?
      puts "That publishable key did not appear to work. Please see the README"
      exit 1
    else
      puts "OK\n"
    end

    # check secret
    print "Checking secret... "
    account = Stripe::Account.retrieve( 'self', secret_key ) rescue nil

    if account.nil?
      puts "That secret key did not appear to work. Please see the README"
      exit 1
    else
      puts "OK\n"
    end

    puts "\nLooks good!"
  end
end
