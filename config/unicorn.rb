preload_app true
worker_processes 8

pid File.expand_path("../../tmp/pids/unicorn.pid", __FILE__)
listen File.expand_path("../../tmp/sockets/unicorn.sock", __FILE__)
stderr_path File.expand_path("../../log/unicorn.stderr.log", __FILE__)
stdout_path File.expand_path("../../log/unicorn.stdout.log", __FILE__)

before_fork do |server, worker|
  ActiveRecord::Base.connection.disconnect!

  # kill old unicorn process
  old_pid = "#{server.config[:pid]}.oldbin"

  if server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ESRCH
      # process do not exists
    rescue Errno::ENOENT
      # pid file do not exists
    end
  end
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
end
