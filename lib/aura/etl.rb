module Aura
  module Etl
    def self.get_connection(namespace)
      Aura::Metadata::DbConnection.new(:namespace => namespace)
    end
  end
end
