module Gitdo
  class Scanner
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def todos
      []
    end
  end
end