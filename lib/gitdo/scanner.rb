module Gitdo
  class Scanner
    attr_reader :path, :tree, :author, :email

    TODO_REGEX = /.*[#\/]\s*TODO:?\s*(\S(.+))\s*$/

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

    def todo_files
      if `ack --version`[0..2] == 'ack'
        files = [];
        ack_dump_lines = `ack --ruby "TODO"`.split("\n")
        ack_dump_lines.each do |line|
          files << line.split(':')[0]
        end
      else
        files = Dir[File.join(path), '**/*.rb'].reject{|f| File.directory?(f)}
      end
      files.select{|f| match_file(f)}
    end

    def each_todo
      if block_given?
        todo_files = self.todo_files

        blobs.each do |blob|
          next unless todo_files.include?(blob[:path])
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

    def match_file(file)
      puts "Matching file: #{file}" if @debug
      return false if binary?(file)
      File.read(file) =~ TODO_REGEX
    rescue
      false
    end

    def build_todo(path, line)
      commit = line.commit
      author = line.commit.author
      Todo.new(comment(line), path, line.lineno, author.name, author.email, commit.authored_date)
    end

    def comment(line)
      line.line =~ TODO_REGEX && $1
    end

    #totally stolen from rdoc
    def binary?(file)
      return false if file =~ /\.(rb|txt)$/

      s = File.read(file, 1024) or return false

      have_encoding = s.respond_to? :encoding

      if have_encoding then
        return false if s.encoding != Encoding::ASCII_8BIT and s.valid_encoding?
      end

      return true if s[0, 2] == Marshal.dump('')[0, 2] or s.index("\x00")

      if have_encoding then
        s.force_encoding Encoding.default_external

        not s.valid_encoding?
      else
        if 0.respond_to? :fdiv then
          s.count("\x00-\x7F", "^ -~\t\r\n").fdiv(s.size) > 0.3
        else # HACK 1.8.6
          (s.count("\x00-\x7F", "^ -~\t\r\n").to_f / s.size) > 0.3
        end
      end
    end
  end
end

