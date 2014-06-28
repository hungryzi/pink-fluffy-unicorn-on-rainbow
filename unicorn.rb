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

def ascii_unicorn
  if @time % 10 > 5
    [
      "          /| ",
      " ~～～～~/ | ",
      "|       O  O ",
      "|         ∇ |",
      " ~~~~∪∪~~~∪∪ "
    ]
  else
    [
      "          /| ",
      " ～～～～/ | ",
      "|       ⌒  ⌒ ",
      "|         ∇ |",
      " ~~∪∪~~~∪∪~~ "
    ]
  end
end

def pinkify(string)
  "\e[35;5;35m#{string}\e[0m"
end

def pink_unicorn
  ascii_unicorn.map{ |line| pinkify(line) }
end

def unicorn_width
  ascii_unicorn.first.size
end

def unicorn
  pink_unicorn.map do |line|
    puts " " * ((terminal_width - unicorn_width) / 2).floor + \
    line + \
    " " * ((terminal_width - unicorn_width) / 2).ceil
  end
end

def pink_fluffy_unicorn_mp3
  File.expand_path('../fluffy_unicorn.mp3', __FILE__)
end

def kill_music
  system("killall -9 afplay &>/dev/null")
end

music = Thread.new do
  loop do
    `afplay #{pink_fluffy_unicorn_mp3} &`
    sleep 97
  end
end

graphic = Thread.new do
  @time = 0
  loop do
    @time += 1

    clear

    unicorn
    rainbow
    puts "Press Ctrl-C to exit..."

    sleep 0.1
  end
end

trap "SIGINT" do
  puts "Exiting"
  kill_music

  graphic.kill
  music.kill
end

music.join
graphic.join

