
# require "ckuru-tools"
# require "aura/etl"

module Aura
  def self.require_all_libs_relative_to( fname, dir = nil )
    dir ||= ::File.basename(fname, '.*')
    search_me = ::File.expand_path(::File.join(::File.dirname(fname), dir, '**', '*.rb'))

    puts ::File.join(::File.dirname(fname), dir, '**', '*.rb')

    Dir.glob(search_me).sort.each {|rb| 
      begin 
        require rb
      rescue Exception => e
      end
    }
  end

end

Aura.require_all_libs_relative_to(__FILE__,"aura")

Aura.require_all_libs_relative_to(__FILE__,"aura")



