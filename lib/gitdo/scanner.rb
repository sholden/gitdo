module Gitdo
  class Scanner
    attr_reader :path, :tree, :author, :email

    def initialize(path, options = {})
      @path = path
      @tree = options[:tree] || 'master'
      @author = options[:author]
      @email = options[:email]
      @debug = options[:debug]
    end

    def repo
      @repo ||= Grit::Repo.new(path)
    end

    def blobs
      repo.lstree(tree, recursive: true).select{|o| o[:type] == 'blob'}
    end

    def each_todo
      if block_given?
        blobs.each do |blob|
          puts "Scanning #{blob[:path]}" if @debug

          blame = blame(File.join(path, blob[:path]))
          if blame
            puts "Found #{blame.lines.length} lines" if @debug
            blame.lines.each do |line|
              yield build_todo(blob[:path], line) if match(line)
            end
          end
        end
      else
        to_enum(:each_todo)
      end
    end

    def blame(path)
      # For some reason blame is blowing up because of an empty commit.id, not sure why this condition is happening.
      repo.blame(path)
    rescue NoMethodError => e
      puts "Blame raised an exception!" if @debug
      raise unless e.message == "undefined method `id' for nil:NilClass"
      nil
    end

    def todos
      each_todo.to_a
    end

  private

    def match(line)
      match = comment(line)
      match &&= line.commit.author == author if author
      match &&= line.commit.email == email if email
      if @debug
        if match
          puts "Matched: #{line.line}"
        else
          puts "Skipped: #{line.line}"
        end
      end
      match
    end

    def build_todo(path, line)
      commit = line.commit
      author = line.commit.author
      Todo.new(comment(line), path, line.lineno, author.name, author.email, commit.authored_date)
    end

    def comment(line)
      line.line =~ /.*[#\/]\s*TODO:?\s*(\S(.+))\s*$/ && $1
    end
  end
end

