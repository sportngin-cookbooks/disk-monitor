define :disk_monitor, :template => "alert.sh.erb", :bin_path => "/usr/local/bin" do
  options = {
    :alert_level => params[:name],
    :app_name => params[:app_name],
    :environment => params[:environment],
    :pd_service_key => params[:pd_service_key],
    :hostname => (params[:hostname] || node[:hostname]),
    :alerting_threshold => (params[:alerting_threshold] || 90),
    :user => (params[:user] || "root"),
    :group => (params[:group] || "root"),
    :template => params[:template],
    :cookbook => (params[:cookbook] || "disk-monitor"),
    :check_frequency => (params[:check_frequency] || 1),
    :bin_path => params[:bin_path]
  }
  options[:bin_file] = params[:bin_file] || "disk-alert-#{options[:alert_level]}"
  options[:bin] = "#{options[:bin_path]}/#{options[:bin_file]}"
  options[:cron_frequency] = options[:check_frequency] == 1 ? "*" : "*/#{options[:check_frequency]}"

  template options[:bin] do
    source options[:template]
    cookbook options[:cookbook]
    owner options[:user]
    group options[:group]
    mode 0755
    variables options
  end

  cron "disk-alert-#{options[:alert_level]}" do
    minute options[:cron_frequency]
    user options[:user]
    command options[:bin] + " > /dev/null 2>&1"
  end

end
