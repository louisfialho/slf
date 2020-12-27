class SpacePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    true  # Anyone can view a restaurant
  end

  def create?
    if @shelf
      @shelf.users.first == user
    end
  end

  def update?
    if !record.shelves.empty?
      record.shelves.first.users.first == user #assuming a space can be in one shelf and one shelf can belong to one user
    # - record: the restaurant passed to the `authorize` method in controller
    # - user:   the `current_user` signed in with Devise.
    elsif !record.connections.first.parent.nil?
      record.connections.first.root.space.shelves.first.users.first == user #assuming a child space can have only one parent space, a parent space can have only one shelf, a shelf can belong only to one user.
    end
  end

  def destroy?
    if !record.shelves.empty?
      record.shelves.first.users.first == user
    elsif !record.connections.first.parent.nil?
      record.connections.first.root.space.shelves.first.users.first == user #assuming a child space can have only one parent space, a parent space can have only one shelf, a shelf can belong only to one user.
    end
  end
end
