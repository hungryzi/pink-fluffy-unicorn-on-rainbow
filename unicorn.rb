def terminal_width
  @terminal_width ||= `stty size`.split.map { |x| x.to_i }.reverse.first - 1
end

def rainbow
  5.times do |row|
    terminal_width.times do |col|
      if col.odd?
        print rainbowify("_", col)
      else
        print rainbowify("-", col)
      end
    end
  end
end

def rainbowify(string, col)
  c = colors[col % colors.size]
  "\e[38;5;#{c}m#{string}\e[0m"
end

def colors
  @colors ||= (0...(6 * 7)).map do |n|
    pi_3 = Math::PI / 3
    n *= 1.0 / 6
    r  = (3 * Math.sin(n           ) + 3).to_i
    g  = (3 * Math.sin(n + 2 * pi_3) + 3).to_i
    b  = (3 * Math.sin(n + 4 * pi_3) + 3).to_i
    36 * r + 6 * g + b + 16
  end
end

rainbow

