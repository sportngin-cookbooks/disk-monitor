define :disk_monitor, :template => "alert.sh.erb", :bin_path => "/usr/local/bin" do
  application = Hash.new("").tap do |a|
    a[:alert_level] = params[:name]
    a[:app_name] = params[:app_name]
    a[:environment] = params[:environment]
    a[:pd_service_key] = params[:pd_service_key]
    a[:hostname] = params[:hostname] || node[:hostname]
    a[:alerting_threshold] = params[:alerting_threshold] || 90
    a[:user] = params[:user] || "root"
    a[:group] = params[:group] || "root"
    a[:template] = params[:template]
    a[:cookbook] = params[:cookbook] || "disk-monitor"
    a[:check_frequency] = params[:check_frequency] || 15
    a[:cron_frequency] = a[:check_frequency] == 1 ? "*" : "*/#{a[:check_frequency]}"
    a[:bin_path] = params[:bin_path]
    a[:bin_file] = params[:bin_file] || "disk-alert-#{a[:alert_level]}"
    a[:bin] = "#{a[:bin_path]}/#{a[:bin_file]}"
  end

  template application[:bin] do
    source application[:template]
    cookbook application[:cookbook]
    user application[:user]
    group application[:group]
    mode 0755
    variables application
  end

  cron "disk-alert-#{application[:alert_level]}" do
    minute a[:cron_frequency]
    user application[:user]
    command application[:bin]
  end

end
