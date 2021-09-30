class PaymentsController < ApplicationController
  # before_action :authenticate_user!
  skip_after_action :verify_authorized, only: [:redirect_stripe]
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  require 'stripe'
  require 'json'


  Stripe.api_key = ENV['STRIPE_SECRET']

  def redirect_stripe
    session = Stripe::Checkout::Session.create({
      client_reference_id: current_user.id,
      customer_email: current_user.email,
      line_items: [{
        price: 'price_1JfRfXJOGJfv8N7HetSmb0n6',
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
