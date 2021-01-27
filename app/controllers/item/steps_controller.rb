class Item::StepsController < ApplicationController
  include Wicked::Wizard
  steps *Item.form_steps

  include Pundit
  after_action :verify_authorized, except: [:update]

  def show
    @item = Item.find(params[:item_id])
    authorize @item
    if params[:shelf_id].present?
      @shelf = Shelf.find(params[:shelf_id])
      render_wizard(nil, {}, { shelf_id: @shelf.id })
    elsif params[:space_id].present?
      @space = Space.find(params[:space_id])
      render_wizard(nil, {}, { space_id: @space.id })
    end
  end

  def update
    @item = Item.find(params[:item_id])
    @item.update(item_params(step))
    if params[:item][:shelf_id].present?
      @shelf = Shelf.find(params[:item][:shelf_id])
      render_wizard(@item, {}, { shelf_id: @shelf.id })
      case step
        when "notes"
          @shelf.items << @item
        end
    elsif params[:item][:space_id].present?
      @space = Space.find(params[:item][:space_id])
      render_wizard(@item, {}, { space_id: @space.id })
      case step
        when "notes"
          @space.items << @item
        end
    end
  end

  private

  def finish_wizard_path
    if @space
      item_path(@item, space_id: @space.id)
    elsif @shelf
      item_path(@item, shelf_id: @shelf.id)
    end
  end

  def item_params(step)
    permitted_attributes = case step
      when "url"
        [:url]
      when "medium"
        [:medium]
      when "name"
        [:name]
      when "status"
        [:status]
      when "rank"
        [:rank]
      when "notes"
        [:notes]
      end

    params.require(:item).permit(permitted_attributes).merge(form_step: step)
  end

end
