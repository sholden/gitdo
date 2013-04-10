module Gitdo
  class ConsoleReporter
    attr_reader :scanner

    def initialize(scanner)
      @scanner = scanner
    end

    def run!
      todo_rows = scanner.todos.sort_by(&:created_at).map{|t| [t.comment, t.line, t.file, t.author, t.created_at]}
      table = Terminal::Table.new headings: %w{Comment Line File Author Created}, rows: todo_rows
      puts table
    end
  end
end