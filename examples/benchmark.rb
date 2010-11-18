#!/usr/bin/env ruby

#
# Runners
#

Frameworks = %w(rails padrino sinatra)

class Runner

  def self.next_port
    @next_port ||= 4000
    @next_port += 1
  end

  attr_reader :path, :port

  def initialize(path, port = Runner.next_port)
    @path, @port = path, port
  end

  def start
    Dir["#{path}/log/*.log"].each { |f| File.delete(f) }
    File.delete(logfile) if File.exists?(logfile)

    puts "Starting #{path} on port #{port}"
    execute "thin start -p #{port} -d -e production -l ../#{logfile}"
  end

  def stop
    puts "Stopping #{path} on port #{port}"
    execute "thin stop -f"
  end

  def logfile
    "thin.#{path}.log"
  end

private

  def execute(command)
    command = "cd #{path} && bundle exec #{command}"
    puts ">> #{command}"
    system(command)
  end

end

requests_num = (ENV['N'] || 1000).to_i
concurrency  = (ENV['C'] || 10).to_i

#
# Benchmark suite
#
runners = Frameworks.map {|f| Runner.new(f)}

def run(runners, requests_num, concurrency)
  puts "Testing frameworks with #{requests_num} requests and #{concurrency} connections: "
  runners.each do |r|
    puts "  #{r.path} on port #{r.port}"
  end

  results = runners.inject({}) do |table, r|
    port = r.port
    name = r.path
    puts "Benchmarking #{name} on port #{port}..."
    cmd = %{ab -c #{concurrency} -n #{requests_num} http://127.0.0.1:#{port}/ 2>/dev/null}
    puts ">> #{cmd}"
    result = `#{cmd}`
    sleep 0.3
    result[/Requests per second:\s*([\d.]+)/]
    rps = $1.to_f

    n = 0; objects = 0; new_objects = 0
    File.foreach(r.logfile) do |line|
      if line =~ /^OC (\d+) => \d+ \(new objects: (\d+)\)/
        objects += $1.to_i
        new_objects += $2.to_i
        n += 1
      end
    end

    table[name] = "%6.1f rps / %6d avg. objs / %4d new objs per req." % [rps, objects / n, new_objects / n]
    table
  end

  name_length = results.keys.map {|k| k.length}.max
  results.to_a.sort_by {|name,_| name}.reverse.each do |name, stats|
    puts "  %#{name_length}s => %s" % [name, stats]
  end
end

def start(runners)
  runners.each { |r| r.start }
  20.downto(0) { |i| print "Test start in #{i}s \r"; $stdout.flush; sleep 1 }
end

def stop(runners)
  runners.each { |r| r.stop }
end

cmd = ARGV[0]

if cmd == 'start'
  start(runners)
  puts ""
  puts ""
  sleep 0.5
  run(runners, requests_num, concurrency)
elsif cmd == 'restart'
  stop(runners)
  sleep 1
  start(runners)
  puts ""
  puts ""
  sleep 2
  run(runners, requests_num, concurrency)
elsif cmd == 'run'
  (ENV['R'] || 1).to_i.times { run(runners, requests_num, concurrency) }
elsif cmd == 'stop'
  stop(runners)
else
  puts "Start and stop servers with ./benchmark.rb start|stop"
  puts "Use './benchmark.rb run' against already booted servers."
  puts
  puts "Environment variables:"
  puts "  R - number of runs (for run command)"
  puts "  N - number of requests, C - concurrency"
  puts "  FORCE_GC - whether to run GC after each request"
  puts
end
