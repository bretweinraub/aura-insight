
module Aura
  module Metadata
    def self.check_adapter(adapter)
      if adapter  == "Pg"
        "postgresql"
      else
        adapter
      end
    end

    class EnvironmentNamespaceConnection < CkuruTools::HashInitializerClass
      instance_of_class_accessor Aura::Metadata::EnvironmentNamespace, :namespace
      instance_of_class_accessor String, :new_class
      instance_of_class_accessor Class, :klass

      def initialize(h={})
        super
        required_attributes :namespace,:new_class

        code = %{
          class #{new_class} < ActiveRecord::Base
            establish_connection(:adapter => Aura::Metadata.check_adapter("#{namespace.type}"),
                                 :host => "#{namespace.HOST}",
                                 :port => #{namespace.PORT},
                                 :username => "#{namespace.USER}",
                                 :password => "#{namespace.PASSWD}",
                                 :database => "#{namespace.DATABASE}")
          end
        }
        eval code
      end
    end
  end
end
