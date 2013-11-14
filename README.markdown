Description
----------

This cookbook is an lwrp for a simple bash/cron disk space based alert


Attributes
----------

* name - Alert level ie default, warn, critical (required)
* pd_service_key - PagerDuty Service key to trigger the alert (required)
* app_name - Name of the application
* hostname - Hostname of the machine the alert was placed on, defaults to node[:hostname]
* alerting_threshold - Disk percentage at which the alert will be triggered, defaults to 90%
* user - User to own and run the script 
* group - Group to own the script
* template - Location of the template file defaults to 'alert.sh.erb'
* cookbook - Change the cookbook to run the lwrp from defaults to this cookbook
* check_frequency - Frequency of the disk check, defaults to every minute
* bin_path - Path to the bin directory to place the alert, defaults to /usr/local/bin
* bin_file -  Name of the alert binary, defaults to disk-alert-NAME

Usage
--------

 ```ruby

disk_monitor "warning" do
  app_name "My App"
  environment "production"
  pd_service_key "1234567890"
  alerting_threshold 80
  user 'root'
  group 'root'
  check_frequency 10
end

```
