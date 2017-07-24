#
# hash_extended.rb
#

module Puppet::Parser::Functions
  newfunction(:hash_extended, :type => :rvalue, :doc => <<-EOS
This function flattens an array and then converts this array into a hash.

*Examples:*
    hash(<array>, [<flatten_level>])
    hash(['a',{'test' => 'test'},'b',2,'c',3], 1) -returns-> {'a'=>{'test' => 'test'},'b'=>2,'c'=>3}
    
Would return:
  EOS
  ) do |arguments|

    raise(Puppet::ParseError, "hash(): Wrong number of arguments given (#{arguments.size} for 2)") if arguments.size < 2

    array = arguments[0]

    unless array.is_a?(Array)
      raise(Puppet::ParseError, 'hash(): Requires array to work with')
    end

    result = {}

    begin
      # This is to make it compatible with older version of Ruby ...
      if arguments[1]
        array  = array.flatten(arguments[1])
      else
        array  = array.flatten
      end

      result = Hash[*array]
    rescue StandardError
      raise(Puppet::ParseError, 'hash(): Unable to compute hash from array given')
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
