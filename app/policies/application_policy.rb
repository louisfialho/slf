class ApplicationPolicy
  attr_reader :user, :record, :request_shelf

  def initialize(context, record)
    @user = context.user
    @record = record
    if !context.instance_values["shelf"].nil?
      @shelf = context.instance_values["shelf"]
    elsif !context.instance_values["parent"].nil?
      @parent = context.instance_values["parent"]
    end
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end
