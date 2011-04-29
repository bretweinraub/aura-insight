module Aura
  module Metadata
    class EnvironmentNamespace < CkuruTools::HashInitializerClass
      attr_accessor :namespace

      def initialize(h={})
        super
        required_attributes(:namespace)

        ENV.keys.each do |k|
#          require 'ruby-debug' ; debugger if k.match /MedEuProd/
          r=Regexp.new("^#{namespace}_(.+)")
          if matchdata = r.match(k)
            ckebug 1, "#{namespace}.#{matchdata[1]} = " + ENV["#{namespace}_#{matchdata[1]}"]
            code = %{
              def self.#{matchdata[1]}
                ENV["#{namespace}_#{matchdata[1]}"]
              end
            }
            self.instance_eval code
          end
        end
      end
    end
  end
end
      
