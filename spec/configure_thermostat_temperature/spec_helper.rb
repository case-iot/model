require_relative '../spec_helper'

class ConfigureThermostatTemperatureLoader < UseCaseLoader
  def initialize(ontology)
    @ontology = ontology
  end

  def app
    n3 = File.read(File.dirname(__FILE__) + '/thermostat_control_app.n3')
    @ontology.load_and_process_n3 n3
  end
end
