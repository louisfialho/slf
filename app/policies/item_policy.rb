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
    if @shelf
      @shelf.user == user
    elsif @parent
      if !@parent.shelves.empty?
        @parent.shelves.first.user == user
      elsif !@parent.connections.first.root.space.shelves.first.user.empty?
        @parent.connections.first.root.space.shelves.first.user == user
      end
    end
  end

  def update?
    if !record.shelves.empty?
      record.shelves.first.user == user # Only shelf holder can update it
    elsif !record.spaces.empty?
      if !record.spaces.first.shelves.empty?
        record.spaces.first.shelves.first.user == user
      else
        record.spaces.first.connections.first.root.space.shelves.first.user == user
      end
    end
  end

  def move_to_space?
    if !record.shelves.empty?
      record.shelves.first.user == user # Only shelf holder can update it
    elsif !record.spaces.empty?
      if !record.spaces.first.shelves.empty?
        record.spaces.first.shelves.first.user == user
      else
        record.spaces.first.connections.first.root.space.shelves.first.user == user
      end
    end
  end

  def move_to_shelf?
    if !record.shelves.empty?
      record.shelves.first.user == user # Only shelf holder can update it
    elsif !record.spaces.empty?
      if !record.spaces.first.shelves.empty?
        record.spaces.first.shelves.first.user == user
      else
        record.spaces.first.connections.first.root.space.shelves.first.user == user
      end
    end
  end

  def destroy?
    if !record.shelves.empty?
      record.shelves.first.user == user # Only shelf holder can update it
    elsif !record.spaces.empty?
      if !record.spaces.first.shelves.empty?
        record.spaces.first.shelves.first.user == user
      else
        record.spaces.first.connections.first.root.space.shelves.first.user == user
      end
    end
  end
end
