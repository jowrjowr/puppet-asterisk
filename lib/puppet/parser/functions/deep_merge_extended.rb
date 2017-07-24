# require 'deep_merge/core'

module Puppet::Parser::Functions
  newfunction(:deep_merge_extended, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
    Recursively merges two or more hashes together and returns the resulting hash.

    For example:

        $hash1 = {'one' => 1, 'two' => 2, 'three' => { 'four' => 4 } }
        $hash2 = {'two' => 'dos', 'three' => { 'five' => 5 } }
        $merged_hash = deep_merge_extended($hash1, $hash2)
        # The resulting hash is equivalent to:
        # $merged_hash = { 'one' => 1, 'two' => 'dos', 'three' => { 'four' => 4, 'five' => 5 } }

    When there is a duplicate key that is a hash, they are recursively merged.
    When there is a duplicate key that is not a hash, the key in the rightmost hash will "win."

  ENDHEREDOC

    if args.length < 2
      raise Puppet::ParseError, ("deep_merge_extended(): wrong number of arguments (#{args.length}; must be at least 2)")
    end

    default_opts = {:knockout_prefix => '--', :preserve_unmergeables => false,
                    :merge_hash_arrays => true, :extend_existing_arrays => true}

    # note that we give args[1] first and then args[0] into deep_merge, since DeepMerge::deep_merge will not overwrite
    # elements which exist in args[1].
    #  Example: {cdr_mysql => {'enable' => true}} :: {cdr_mysql => {'enable' => false}} results in
    #  Example-Result: {cdr_mysql => {'enable' => true}}
    #
    DeepMerge::deep_merge!(args[1], args[0], default_opts)
  end
end
