define :disk_monitor, :alerting_threshold => 90, :template => "alert.sh.erb", :bin_path => "/usr/local/bin/disk-alert" do
  application = Hash.new("").tap do |a|
    a[:app_name] = params[:app_name]
    a[:environment] = params[:environment]
    a[:pd_service_key] = params[:pd_service_key]
    a[:hostname] = params[:hostname] || node[:hostname]
    a[:alerting_threshold] = params[:alerting_threshold].to_i
    a[:user] = params[:user] || "root"
    a[:group] = params[:group] || "root"
    a[:template] = params[:template]
    a[:cookbook] = params[:cookbook] || "disk-monitor"
    a[:check_frequency] = params[:check_frequency] || 15
    a[:bin_path] = params[:bin_path]
  end

  template a[:bin_path] do
    source a[:template]
    cookbook a[:cookbook]
    user a[:user]
    group a[:group]
    chmod 0755
    variables application
  end

  cron "disk-alert" do
    minute "*/#{a[:check_frequency]}"
    user a[:user]
    command a[:bin_path]
  end

end
