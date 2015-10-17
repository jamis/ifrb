if !defined? IRB
  abort "ifrb will only work within an IRB session"
end

IRB.conf[:PROMPT][:IFRB] = {
  :PROMPT_I => "%N> ",  # "initial" prompt
  :PROMPT_C => "..",    # continued command
  :PROMPT_S => "..",    # continued string
  :PROMPT_N => "..",    # nested command
  :RETURN => ""         # formatting for return values
}

def ifrb(game)
  context.prompt_mode = :IFRB

  class <<self
    def method_missing(sym, *args)
      if args.empty?
        sym
      else
        super
      end
    end
  end

  def _load_room(name)
    context.irb_name = name

    (methods - @_baseline).each do |method|
      eval "undef #{method}"
    end

    send(name)

    look if respond_to?(:look)
  end

  def _format(text, length:60, indent:2)
    indent = " " * indent

    text.each_line do |line|
      line.strip!

      if line.empty?
        puts
      else
        while line.length > length
          break_at = length
          break_at -= 1 while break_at > 0 && line[break_at] != " "
          break_at = length if break_at == 0
          puts indent + line[0, break_at]
          line = line[break_at+1..-1]
        end

        puts indent + line if line.length > 0
      end
    end

    nil
  end

  load "#{game}.rb"
  @_baseline = methods

  _load_room :start
end
