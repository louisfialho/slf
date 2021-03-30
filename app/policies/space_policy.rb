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
    # if @shelf
    #   @shelf.user == user
    # elsif @parent
    #   if !@parent.shelves.empty?
    #     @parent.shelves.first.user == user
    #   else
    #     @parent.connections.last.root.space.shelves.first.user == user  #assuming a child space can have only one parent space, a parent space can have only one shelf, a shelf can belong only to one user.
    #   end
    # end
  end

  def update?
    if !record.shelves.empty?
      record.shelves.first.user == user #assuming a space can be in one shelf and one shelf can belong to one user
    elsif !record.connections.first.parent.nil?
      record.connections.first.root.space.shelves.first.user == user #assuming a child space can have only one parent space, a parent space can have only one shelf, a shelf can belong only to one user.
    end
  end

  def destroy?
    true
    # if !record.shelves.empty?
    #   record.shelves.first.user == user
    # elsif !record.connections.last.parent.nil?
    #   record.connections.last.root.space.shelves.first.user == user #assuming a child space can have only one parent space, a parent space can have only one shelf, a shelf can belong only to one user.
    # end
  end

  def move_space_to_space?
    true
    # if !record.shelves.empty?
    #   record.shelves.first.user == user
    # elsif !record.connections.first.parent.nil?
    #   record.connections.first.root.space.shelves.first.user == user #assuming a child space can have only one parent space, a parent space can have only one shelf, a shelf can belong only to one user.
    # end
  end

  def move_space_to_shelf?
    true
    # if !record.shelves.empty?
    #   record.shelves.first.user == user
    # elsif !record.connections.first.parent.nil?
    #   record.connections.first.root.space.shelves.first.user == user #assuming a child space can have only one parent space, a parent space can have only one shelf, a shelf can belong only to one user.
    # end
  end

end
