Stripe.api_key = 'sk_test_51JdJZZJOGJfv8N7Hn56e98m01gZz01ffu3jmMEwRVaNnFVCdvczLwaEo8EQimYNqE535w0If7EEU8xV04Rx14sn700pvRcxzGO'

require 'sinatra'

# You can find your endpoint's secret in the output of the `stripe listen`
# command you ran earlier
endpoint_secret = 'whsec_60TXAzLq6tVVY9MUwIu2bW6oqGLIrKj6'

post '/webhook' do
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
  # TODO: fill in with your own logic
  puts "Fulfilling order for #{checkout_session.inspect}"
  user = User.first
  user.tts_balance_in_min = 150
  user.save
end
