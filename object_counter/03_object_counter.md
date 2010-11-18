!SLIDE
# Tracking the number of Objects

    @@@ shell
    $ irb -f
    irb(main):001:0> ObjectSpace.each_object {}
    => 10809

!SLIDE
# ObjectCounter middleware

    @@@ ruby
    # object_counter.rb
    class ObjectCounter
      def initialize(app, force_gc = false)
        @app = app
        @force_gc = force_gc
      end

      def call(env)
        count_before = ObjectSpace.each_object {}
        ret = @app.call(env)
        count_after = ObjectSpace.each_object {}
        puts "OC #{count_before} => #{count_after} (new objects: #{count_after - count_before})"
        GC.start if @force_gc
        ret
      end
    end

    # config.ru
    require 'object_counter'
    require 'app'

    use ObjectCounter, :force_gc
    run App

!SLIDE
# Simple benchmarks

## using small, simple and functionally identical Sinatra, Padrino and Rails applications

## benchmark sources available in `examples/`
## ObjectCounter in `examples/object_counter.rb`

!SLIDE
## without GC runs

    @@@
    $ N=1000 C=10 ./benchmark.rb start
    ...
    Testing frameworks with 1000 requests and 10 connections: 
      rails on port 4001
      padrino on port 4002
      sinatra on port 4003
    Benchmarking rails on port 4001...
    >> ab -c 10 -n 1000 http://127.0.0.1:4001/ 2>/dev/null
    Benchmarking padrino on port 4002...
    >> ab -c 10 -n 1000 http://127.0.0.1:4002/ 2>/dev/null
    Benchmarking sinatra on port 4003...
    >> ab -c 10 -n 1000 http://127.0.0.1:4003/ 2>/dev/null
      sinatra =>   59.7 rps /  71441 avg. objs /  432 new objs per req.
        rails =>   34.3 rps / 123113 avg. objs /  989 new objs per req.
      padrino =>   35.4 rps / 127172 avg. objs /  499 new objs per req.

!SLIDE
## with GC runs

    @@@
    $ FORCE_GC=1 N=1000 C=10 ./benchmark.rb start
    ...
    Testing frameworks with 1000 requests and 10 connections: 
      rails on port 4001
      padrino on port 4002
      sinatra on port 4003
    Benchmarking rails on port 4001...
    >> ab -c 10 -n 1000 http://127.0.0.1:4001/ 2>/dev/null
    Benchmarking padrino on port 4002...
    >> ab -c 10 -n 1000 http://127.0.0.1:4002/ 2>/dev/null
    Benchmarking sinatra on port 4003...
    >> ab -c 10 -n 1000 http://127.0.0.1:4003/ 2>/dev/null
      sinatra =>   42.1 rps /  55321 avg. objs /  432 new objs per req.
        rails =>   22.0 rps /  93780 avg. objs /  988 new objs per req.
      padrino =>   22.3 rps /  95894 avg. objs /  499 new objs per req.

!SLIDE bullets
# Benchmark summary

* Sinatra about twice as fast, about half the number of objects
* Rails and Padrino are on par
* explicit GC runs help in seeing the real picture
