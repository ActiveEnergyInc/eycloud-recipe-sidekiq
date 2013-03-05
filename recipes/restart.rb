if sidekiq_instance?
  execute "ensure-sidekiq-is-setup-with-monit" do 
    command "monit reload"
  end

  node[:applications].each do |app_name, data|

    # Only restart applications that use Sidekiq.
    next unless node[:sidekiq][:applications].include?(app_name)

    execute "restart-sidekiq" do 
      command %Q{ 
        echo "sleep 20 && monit -g #{app_name}_sidekiq restart all" | at now 
      }
    end
  end
end
