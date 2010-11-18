class ObjectCounter
  def initialize(app)
    @app = app
    @force_gc = ENV['FORCE_GC'] && ENV['FORCE_GC'] != ""
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
