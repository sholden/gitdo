module Gitdo
  class Todo
    attr_reader :user, :comment, :updated_at

    def initialize(user, comment, updated_at)
      @user, @comment, @updated_at = user, comment, updated_at
    end
  end
end