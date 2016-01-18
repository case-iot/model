class ApplicationByCapabilityFinder
  def initialize(ontology)
    @ontology = ontology
  end

  def find(options)
    solutions = RDF::Query.execute(@ontology, {
      application: {
        LV.hasDeploymentPlan => {
          LV.capability => options
        }
      }
    })

    solutions.map do |solution|
      solution[:application]
    end.uniq.map do |node|
      Application.new(node, @ontology)
    end
  end

  def find_by_type(type)
    find({ RDF.type => type })
  end

  def find_by_description(description)
    find({ LV.description => description })
  end

  def find_by_actuator(actuator)
    find({ LV.actuator => actuator })
  end

  def find_by_sensor(sensor)
    find({ LV.sensor => sensor })
  end
end
