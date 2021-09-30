class WebhookEventsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!, except: [:create]
  after_action :verify_authorized, except: [:create]

  def create

    if !signatures_valid?
      render json: {message: "signature invalid"}, status: 400
      return
    end

    #idempotent
    if !WebhookEvent.find_by(external_id: external_id, source: params[:source]).nil?
      render json: { message: "Already processed #{external_id}"}
      return
    end

    event = WebhookEvent.create!(webhook_params)
    case params[:source]
    when 'stripe'
      case params[:type]
      when 'checkout.session.completed'
        if params[:data]
          user_id = params[:data][:object][:client_reference_id]
          user = User.find(user_id)
          if user.tts_balance_in_min.nil?
            user.tts_balance_in_min = 150
          else
            user.tts_balance_in_min += 150
          end
          user.save
        end
      end
    end
    render json: params
  end

  def signatures_valid?
    if params[:source] == 'stripe'
      begin
        wh_secret = ENV['STRIPE_SIGNING_SECRET']
        Stripe::Webhook.construct_event(
          request.body.read,
          request.env['HTTP_STRIPE_SIGNATURE'],
          wh_secret
        )
      rescue Stripe::SignatureVerificationError => e
        return false
      end
    end

    true
  end

  def external_id
    return params[:id] if params[:source] == 'stripe'
    SecureRandom.hex
  end

  def webhook_params
    {
      source: params[:source],
      data: params.except(:source, :controller, :action).permit!,
      external_id: external_id
    }
  end
end
