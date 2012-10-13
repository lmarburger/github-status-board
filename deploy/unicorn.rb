app_dir = File.expand_path('../..', __FILE__)

worker_processes 2

working_directory app_dir

# for super-fast worker spawn times
# preload_app true

# Restart any workers that haven't responded in 30 seconds
timeout 30

listen "#{app_dir}/tmp/sockets/unicorn.sock", :backlog => 1024
pid    "#{app_dir}/tmp/pids/unicorn.pid"

# http://www.rubyenterpriseedition.com/faq.html#adapt_apps_for_cow
if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

# after_fork do |server, worker|
#   ActiveRecord::Base.establish_connection
# end
