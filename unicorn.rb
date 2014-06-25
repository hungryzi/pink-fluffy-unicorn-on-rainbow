def terminal_width
  @terminal_width ||= `stty size`.split.map { |x| x.to_i }.reverse.first - 1
end

def rainbow
  5.times do |row|
    terminal_width.times do |col|
      rainbow_index = @time + col
      if rainbow_index.odd?
        print rainbowify("_", rainbow_index)
      else
        print rainbowify("-", rainbow_index)
      end
    end
    print "\n"
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

def clear
  print "\e[H\e[2J"
end

@time = 0
loop do
  @time += 1

  clear
  rainbow
  puts "Press Ctrl-C to exit..."

  sleep 0.1
end

