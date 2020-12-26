class ShelfPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all  # For a multi-tenant SaaS app, you may want to use: scope.where(user: user)
    end
  end

  def show?
    true  # Anyone can view a restaurant
  end

  def create?
    return true
  end

  def update?
    record.users.first == user #(assuming 1 user per shelf)
    # - record: the restaurant passed to the `authorize` method in controller
    # - user:   the `current_user` signed in with Devise.
  end

  def destroy?
    record.users.first == user #(assuming 1 user per shelf)
  end
end
