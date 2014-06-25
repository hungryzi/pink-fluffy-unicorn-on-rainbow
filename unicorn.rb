def terminal_width
  @terminal_width ||= `stty size`.split.map { |x| x.to_i }.reverse.first - 1
end

def rainbow
  5.times do |row|
    terminal_width.times do |col|
      if col.odd?
        print '-'
      else
        print '_'
      end
    end
    print "\n"
  end
end

rainbow

