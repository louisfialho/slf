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
      @shelf.users.first == user
    elsif @parent
      if !@parent.shelves.empty?
        @parent.shelves.first.users.first == user
      else
        @parent.connections.first.root.space.shelves.first.users.first == user
      end
    end
  end

  def update?
    if !record.shelves.empty?
      record.shelves.first.users.first == user # Only shelf holder can update it
    elsif !record.spaces.empty?
      if !record.spaces.first.shelves.empty?
        record.spaces.first.shelves.first.users.first == user
      else
        record.spaces.first.connections.first.root.space.shelves.first.users.first == user
      end
    end
  end

  def destroy?
    if !record.shelves.empty?
      record.shelves.first.users.first == user # Only shelf holder can update it
    elsif !record.spaces.empty?
      if !record.spaces.first.shelves.empty?
        record.spaces.first.shelves.first.users.first == user
      else
        record.spaces.first.connections.first.root.space.shelves.first.users.first == user
      end
    end
  end
end