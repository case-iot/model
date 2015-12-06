require_relative '../spec_helper'

def load_thermostat_definition(repo)
  read_def(repo, File.dirname(__FILE__) + '/thermostat.n3')
end

def load_app_definition(repo)
  read_def(repo, File.dirname(__FILE__) + '/thermostat_control_app.n3')
end
