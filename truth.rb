require 'sinatra'
require 'sinatra/reloader'

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
  table = Array.new
  n = size.to_i

  (2**n).times do |index|
    result = Array.new
    logic_and = true
    logic_or = false
    logic_nand = false
    logic_nor = true
    # logic_xor = false

    n.times do |i|
      if (index/2**(n-i-1))%2 == 1
        logic_or = true
        logic_nor = false
        # logic_xor = !logic_xor
        result << true
      else
        logic_and = false
        logic_nand = true
        result << false
      end
    end
    result << logic_and
    result << logic_or
    result << logic_nand
    result << logic_nor
    # result << logic_xor
    table << result
  end

  # show the table
  erb :display, :locals => {ts: ts, fs: fs, size: size, table: table,}
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
