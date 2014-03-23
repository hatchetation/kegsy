# This class introduces some additional behavior to the Module class
# primarily so that we can make use of class level attr_accessors.
# Snagged from: https://github.com/rubyworks/facets/blob/91bafa187666971556f2f4208fee299d449cd1f9/lib/core/facets/module/mattr.rb
class Module

  # Creates a class-variable attribute that can
  # be accessed both on an instance and class level.
  def cattr(*syms)
    writers, readers = syms.flatten.partition{ |a| a.to_s =~ /=$/ }
    writers = writers.map{ |e| e.to_s.chomp('=').to_sym }

    cattr_reader(*readers)
    cattr_writer(*writers)

    return readers + writers
  end

  # Creates a class-variable attr_reader that can
  # be accessed both on an instance and class level.
  def cattr_reader(*syms)
    syms.flatten.each do |sym|
      module_eval(<<-EOS, __FILE__, __LINE__)
        unless defined? @@#{sym}
          @@#{sym} = nil
        end

        def self.#{sym}
          @@#{sym}
        end

        def #{sym}
          @@#{sym}
        end
      EOS
    end
    return syms
  end

  # Creates a class-variable attr_writer that can
  # be accessed both on an instance and class level.
  def cattr_writer(*syms)
    syms.flatten.each do |sym|
      module_eval(<<-EOS, __FILE__, __LINE__)
        unless defined? @@#{sym}
          @@#{sym} = nil
        end

        def self.#{sym}=(obj)
          @@#{sym} = obj
        end

        def #{sym}=(obj)
          @@#{sym}=(obj)
        end
      EOS
    end
    return syms
  end

  # Creates a class-variable attr_accessor that can
  # be accessed both on an instance and class level.
  def cattr_accessor(*syms)
    cattr_reader(*syms) + cattr_writer(*syms)
  end

  # Creates a class-variable attribute that can
  # be accessed both on an instance and class level.
  def mattr(*syms)
    writers, readers = syms.flatten.partition{ |a| a.to_s =~ /=$/ }
    writers = writers.collect{ |e| e.to_s.chomp('=').to_sym }

    mattr_writer( *writers )
    mattr_reader( *readers )

    return readers + writers
  end

  # Creates a class-variable attr_reader that can
  # be accessed both on an instance and class level.
  def mattr_reader( *syms )
    syms.flatten.each do |sym|
      module_eval(<<-EOS, __FILE__, __LINE__)
        unless defined? @@#{sym}
          @@#{sym} = nil
        end

        def self.#{sym}
          @@#{sym}
        end

        def #{sym}
          @@#{sym}
        end
      EOS
    end
    return syms
  end

  # Creates a class-variable attr_writer that can
  # be accessed both on an instance and class level.
  def mattr_writer(*syms)
    syms.flatten.each do |sym|
      module_eval(<<-EOS, __FILE__, __LINE__)
        unless defined? @@#{sym}
          @@#{sym} = nil
        end

        def self.#{sym}=(obj)
          @@#{sym} = obj
        end

        def #{sym}=(obj)
          @@#{sym}=(obj)
        end
      EOS
    end
    return syms
  end

  # Creates a class-variable attr_accessor that can
  # be accessed both on an instance and class level.
  def mattr_accessor(*syms)
    mattr_reader(*syms) + mattr_writer(*syms)
  end

end
