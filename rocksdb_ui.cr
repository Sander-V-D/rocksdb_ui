require "http/server"
require "rocksdb"
require "json"
RESULTS_PER_PAGE = 100;
html_page = File.read("index.html");
db = RocksDB::DB.new("#{Path[ARGV[0]].expand(home: true)}")
server = HTTP::Server.new do |context|
  context.response.content_type = "text/html"
  if context.request.path == "/"
    result = context.request.query_params.has_key?("page") ? html_page.gsub("let currentPage = 0", "let currentPage = #{context.request.query_params["page"].to_i - 1}") : html_page
    context.response.print result 
  elsif context.request.path == "/query" && context.request.method == "GET"
    result = [] of NamedTuple(key: String, value: String)
    it = RocksDB::StringIterator.new(db)
    if context.request.query_params.has_key?("prefix")
        it.seek(context.request.query_params["prefix"])
    else
        it.first
    end
    count = 0
    start = context.request.query_params.has_key?("page") ? context.request.query_params["page"].to_i * RESULTS_PER_PAGE : 0
    while count < start + RESULTS_PER_PAGE && it.valid?
        result << {"key": it.key, "value": it.value} if count >= start
        it.next
        count += 1
    end
    it.close
    context.response.print result.to_json
  elsif context.request.path == "/update" && context.request.method == "PUT"
    key = context.request.query_params["key"]?
    val = context.request.query_params["val"]?
    next if key.nil? || val.nil?
    puts
    puts "Writing #{key} => #{val}"
    puts "Old value: #{db.get?(key)}"
    db.put(key, val)
  elsif context.request.path == "/update_key" && context.request.method == "PUT"
    old_key = context.request.query_params["old_key"]?
    new_key = context.request.query_params["new_key"]?
    next if new_key.nil? || old_key.nil? 
    val = db.get?(old_key)
    next if val.nil?
    puts
    puts "Updating keys: #{old_key} => #{new_key}"
    puts "Value: #{val}"
    db.delete(old_key)
    db.put(new_key, val)
  elsif context.request.path == "/delete" && context.request.method == "DELETE"
    key = context.request.query_params["key"]?
    next if key.nil?
    puts
    puts "Deleting key #{key}"
    puts "Old value: #{db.get?(key)}"
    db.delete(key)
  elsif context.request.path == "/new" && context.request.method == "POST"
    context.response.status = HTTP::Status::BAD_REQUEST
    key = nil
    val = nil
    next if context.request.body.nil?
    params = URI::Params.parse(context.request.body.not_nil!.gets_to_end)
    key = params["key"]?
    val = params["val"]?
    next if key.nil? || val.nil?
    next unless db.get?(key).nil?
    puts "Putting #{key} => #{val}"
    db.put(key, val)
    context.response.status = HTTP::Status::NO_CONTENT
  else
    context.response.status = HTTP::Status::NOT_FOUND
  end
end
address = server.bind_tcp 8080
puts "Listening on http://#{address}"
Signal::INT.trap do
  puts "Closing server!"
  db.close
  exit(0)
end
server.listen