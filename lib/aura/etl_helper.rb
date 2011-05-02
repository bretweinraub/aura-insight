module Aura
  class EtlHelper < CkuruTools::HashInitializerClass
    attr_accessor :source_namespace
    attr_accessor :target_namespace

    attr_accessor :sourceDB
    attr_accessor :targetDB
    attr_accessor :sourceRD,:targetRD

    #
    # when the original primary key was 'id'; we map it to 'original_id'
    #
    def original_primary_key
      if sourceRD.naturalKey == "id"
        "original_id"
      else
        sourceRD.naturalKey
      end
    end

    #takes a set of keys and rewrites them for a replicated table
    def rewrite_attributes(h={})
      row, original_primary_key, record_class \
        = only_these_parameters(h,
                                [:row,{:instance_that_inherits_from => ActiveRecord::Base,:required => true}],
                                [:original_primary_key,{:instance_that_inherits_from => String,:required => true}],
                                [:record_class,{:klass_that_inherits_from => ActiveRecord::Base,:required => true}]
                                )


      new = Hash.new
      row.attributes.keys.each do |k|
        new_key = k.downcase
        if new_key == record_class.primary_key
          if new_key == original_primary_key
            ckebug 0, "mapping #{new_key} from #{record_class.primary_key}"
            new_key = "original_#{new_key}"
          else
            ckebug 1, "skipping attribute #{new_key}; assuming this is the system generated key"
            next
          end
        end
        new[new_key] = row.attributes[k]
      end
      return new
    end

    #
    def initialize(h={})
      super
      
      required_attributes(:source_namespace,:target_namespace)

      self.sourceDB = Aura::Metadata::EnvironmentNamespace.new(:namespace => source_namespace)
      Aura::Metadata::EnvironmentNamespaceConnection.new(:namespace => sourceDB,
                                                         :new_class => "::Source")

      self.targetDB = Aura::Metadata::EnvironmentNamespace.new(:namespace => target_namespace)

      Aura::Metadata::EnvironmentNamespaceConnection.new(:namespace => targetDB,
                                                         :new_class => "::Target")

      self.sourceRD = Aura::Metadata::EnvironmentNamespace.new(:namespace => ENV["sourceRD"])
      self.targetRD = Aura::Metadata::EnvironmentNamespace.new(:namespace => ENV["targetRD"])
    end
  end
end

      
