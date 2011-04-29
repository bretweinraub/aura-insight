module Aura
  module Metadata
    class DbConnection < CkuruTools::HashInitializerClass
      attr_accessor :namespace
      def initialize(h={})
        super

        required_attributes(:namespace)
      end
    end
  end
end
