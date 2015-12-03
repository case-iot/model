class AppCompatibilityReasoner
  def initialize(app)
    @app = app
    @app_query = app.query
  end

  def compatible?
    graph_names = @app_query.values(LV.compatibility_condition)
    return false unless graph_names.any?

    graph_names.each do |graph_name|
      repository = @app_query.repository
      reasoner = Reasoner.new(repository)

      condition_passed = reasoner.check_condition(graph_name)
      return false unless condition_passed
    end
    true
  end
end
