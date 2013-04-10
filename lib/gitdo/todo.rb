module Gitdo
  class Todo
    attr_reader :comment, :file, :line, :author, :email, :created_at

    def initialize(comment, file, line, author, email, created_at)
      @comment, @file, @line, @author, @email, @created_at =  comment, file, line, author, email, created_at
    end
  end
end