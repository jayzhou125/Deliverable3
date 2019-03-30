require 'sinatra'
require 'sinatra/reloader'

# generate the table
def generate_table(ts, fs, size)
  puts "this method is called"
  table = Array.new(2**@size.to_i){Array.new(@size.to_i)}
  table.each_with_index do |row, r|
    row.each_with_index do |_, c|
      if r/2**c == 0
        table[r][c] == @fs
      else r/2**c == 1
        table[r][c] == @ts
      end
    end
  end
  table
end

# Show the truth table
get '/display' do
  # get the params
  ts = params['ts']
  puts "ts is #{ts}"
  fs = params['fs']
  puts "fs is #{fs}"
  size = params['size']
  puts "size is #{size}"

  # set default value
  if ts == ''
    ts = 'T'
    puts "ts is #{ts}"
  end
  if fs == ''
    fs = 'F'
    puts "fs is #{fs}"
  end
  if size == ''
    size = '3'
    puts "size is #{size}"
  end

  # check params
  if ts.length > 1 || fs.length > 1 || size.to_i < 2 || ts == fs
    puts "The params are invalid."
    return erb :error
  elsif
    begin
      Integer(size)
    rescue
      return erb :error
    end
  end

  # generate the table
  table = generate_table(ts, fs, size)
  puts "#{table}"

  # show the table
  erb :display, :locals => { table: table, ts: ts, fs: fs, size: size}
end

# If a GET request comes in at /, do the following.
get '/' do
  erb :main
end

# What to do if we can't find the route
not_found do
  status 404
  erb :invalid
end