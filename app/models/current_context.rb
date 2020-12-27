class CurrentContext
  attr_reader :user, :shelf

  def initialize(user, shelf)
    @user = user
    @shelf = shelf
  end
end
