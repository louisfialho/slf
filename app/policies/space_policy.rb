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
    true
  end

  def update?
    if !record.shelves.empty?
      record.shelves.first.users.first == user #assuming a space can be in one shelf and one shelf can belong to one user
    # - record: the restaurant passed to the `authorize` method in controller
    # - user:   the `current_user` signed in with Devise.
    end
  end

  def destroy?
    if !record.shelves.empty?
      record.shelves.first.users.first == user
    end
  end
end
