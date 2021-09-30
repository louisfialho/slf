class PaymentsController < ApplicationController
  # before_action :authenticate_user!
  skip_after_action :verify_authorized, only: [:redirect_stripe]
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  require 'stripe'

  Stripe.api_key = ENV['STRIPE_SECRET']

  endpoint_secret = ENV['STRIPE_SIGNING_SECRET']

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

  def receive
    event = nil

    # Verify webhook signature and extract the event
    # See https://stripe.com/docs/webhooks/signatures for more information.
    begin
      sig_header = request.env['HTTP_STRIPE_SIGNATURE']
      payload = request.body.read
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError => e
      # Invalid payload
      return status 400
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      return status 400
    end

    if event['type'] == 'checkout.session.completed'
      checkout_session = event['data']['object']

      fulfill_order(checkout_session)
    end

    status 200
  end

  def fulfill_order(checkout_session)
    user_id = checkout_session['client_reference_id']
    @user = User.find(user_id)
    if @user.tts_balance_in_min.nil?
      @user.tts_balance_in_min = 150
    else
      @user.tts_balance_in_min += 150
    end
    @user.save
  end
end
