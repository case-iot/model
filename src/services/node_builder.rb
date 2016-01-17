require 'securerandom'

class NodeBuilder
  def self.create(properties, repository)
    node = generate_node
    query = NodeQuery.new node, repository

    properties.each do |key, v|
      values = if v.is_a?(Array)
                 v
               else
                 [ v ]
               end

      values.each do |value|
        query.set_value(key,
          if value.is_a?(Hash)
            create(value, repository)
          else
            value
          end, false)
      end
    end

    node
  end

  private

  def self.generate_node
    id = SecureRandom.hex
    RDF::URI("http://example.org/#{id}")
  end
end
