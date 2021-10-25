class ItemPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    true # Anyone can view an item
  end

  def create?
    true
    # if @shelf
    #   @shelf.user == user
    # elsif @parent
    #   if !@parent.shelves.empty?
    #     @parent.shelves.first.user == user
    #   elsif !@parent.connections.first.root.space.shelves.empty?
    #     @parent.connections.first.root.space.shelves.first.user == user
    #   end
    # end
  end

  def update?
    true
    # if !record.shelves.empty?
    #   record.shelves.first.user == user # Only shelf holder can update it
    # elsif !record.spaces.empty?
    #   if !record.spaces.first.shelves.empty?
    #     record.spaces.first.shelves.first.user == user
    #   else
    #     record.spaces.first.connections.first.root.space.shelves.first.user == user
    #   end
    # end
  end

  def move_to_space?
    true
    # if !record.shelves.empty?
    #   record.shelves.first.user == user # Only shelf holder can update it
    # elsif !record.spaces.empty?
    #   if !record.spaces.first.shelves.empty?
    #     record.spaces.first.shelves.first.user == user
    #   else
    #     record.spaces.first.connections.first.root.space.shelves.first.user == user
    #   end
    # end
  end

  def move_to_shelf?
    true
    # if !record.shelves.empty?
    #   record.shelves.first.user == user # Only shelf holder can update it
    # elsif !record.spaces.empty?
    #   if !record.spaces.first.shelves.empty?
    #     record.spaces.first.shelves.first.user == user
    #   else
    #     record.spaces.first.connections.first.root.space.shelves.first.user == user
    #   end
    # end
  end

  def destroy?
    true
    # if !record.shelves.empty?
    #   record.shelves.first.user == user # Only shelf holder can update it
    # elsif !record.spaces.empty?
    #   if !record.spaces.first.shelves.empty?
    #     record.spaces.first.shelves.first.user == user
    #   else
    #     record.spaces.first.connections.first.root.space.shelves.first.user == user
    #   end
    # end
  end

  def move?
    true
  end

  def persist_mp3_url?
    true
  end

  def persist_audio_timestamp?
    true
  end

end
