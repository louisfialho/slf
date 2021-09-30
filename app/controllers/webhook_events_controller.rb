class WebhookEventsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!, except: [:create]
  after_action :verify_authorized, except: [:create]

  def create
    case params[:source]
    when 'stripe'
      case params[:type]
      when 'checkout.session.completed'
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
    render json: params
  end
end
