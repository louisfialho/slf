class CurrentContext
  attr_reader :user, :parent

  def initialize(user, context)
    @user = user
    if !context.nil?
      if context.first == 'shelf'
        @shelf = context.second
      elsif context.first == 'parent'
        @parent = context.second
      end
    end
  end

end


