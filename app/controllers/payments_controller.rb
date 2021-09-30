class PaymentsController < ApplicationController
  # before_action :authenticate_user!
  skip_after_action :verify_authorized, only: [:redirect_stripe]
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  require 'stripe'
  require 'json'


  # Stripe.api_key = ENV['STRIPE_SECRET']

  Stripe.api_key = 'sk_test_51JdJZZJOGJfv8N7Hn56e98m01gZz01ffu3jmMEwRVaNnFVCdvczLwaEo8EQimYNqE535w0If7EEU8xV04Rx14sn700pvRcxzGO'

  # endpoint_secret = ENV['STRIPE_SIGNING_SECRET']

  endpoint_secret = 'whsec_60TXAzLq6tVVY9MUwIu2bW6oqGLIrKj6'

  def redirect_stripe
    session = Stripe::Checkout::Session.create({
      client_reference_id: current_user.id,
      customer_email: current_user.email,
      line_items: [{
        price: 'price_1JezwgJOGJfv8N7H1ihB007u',
        quantity: 1,
      }],
      payment_method_types: [
        'card',
      ],
      mode: 'payment',
      success_url: 'https://www.shelf.so' + '/shelves/' + current_user.username, # à changer pr revenir vers l'item depuis lequel l'utilisateur a cliqué sur wallet
      cancel_url: 'https://www.shelf.so' + '/payment',
    })
    redirect_to(session.url)
  end
end
