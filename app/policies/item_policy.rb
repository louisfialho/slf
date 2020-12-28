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
    #if @shelf
    @shelf.users.first == user
    #elsif @parent
  end

  def update?
    #if !record.shelves.empty?
    record.shelves.first.users.first == user # Only shelf holder can update it
    #elsif !record.spaces.empty?
  end

  def destroy?
    #if !record.shelves.empty?
    record.shelves.first.users.first == user # Only shelf holder can destroy it
    #elsif !record.spaces.empty?
  end
end
