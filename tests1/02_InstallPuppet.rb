# Puppet Installer
# Accepts hash of parsed config file as arg
class InstallPuppet
  attr_accessor :config, :fail_flag 
  def initialize(config)
    self.config    = config
    self.fail_flag = 0

    host=""
    os=""
    test_name="Install Puppet"
    usr_home=ENV['HOME']
    
    # Execute install on each host
    @config.host_list.each do |host, os|
      if /^PMASTER/ =~ os then         # Detect Puppet Master node
        BeginTest.new(host, test_name)
        runner = RemoteExec.new(host)
        #result = runner.do_remote("./install.sh -foo -bar")
        result = runner.do_remote("uname -a")
        p result.output
        @fail_flag+=result.exit_code
        ChkResult.new(host, test_name, result.exit_code, result.output)
      elsif /^AGENT/ =~ os then        # Detect Puppet Agent node
        BeginTest.new(host, test_name)
        runner = RemoteExec.new(host)
        #result = runner.do_remote("./install.sh -foo -bar")
        result = runner.do_remote("uname -a")
        p result.output
        @fail_flag+=result.exit_code
        ChkResult.new(host, test_name, result.exit_code, result.output)
      end
    end
  end
end
