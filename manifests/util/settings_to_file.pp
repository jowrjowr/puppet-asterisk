# Use a hash of options and put them into asterisk friendly ini files
#
define asterisk::util::settings_to_file (
  Hash[String, Hash] $standardsettings = {},
  Optional[Hash[String, Hash]] $standardsettings2 = {},
  Hash[String, Struct[{
    'sep'         => Optional[String],
    'is_template' => Optional[Boolean],
    'data'        => NotUndef,
  }]] $specialsettings = {},
  String $owner = 'root',
  String $group = 'asterisk',
  String $mode  = '0640',
  Boolean $manage_dotd_includes = true,
  Array $includes = [],
  String $includes_file_suffix = '*.conf',
  String $seperator = '=',
  String $array_separator = ',',
  Hash[String, String] $special_separator_fields = {},
  String $template = 'asterisk/asterisk_conf_rocket.epp',
) {
  concat { $name:
    ensure => present,
    owner  => $owner,
    group  => $group,
    mode   => $mode,
  }

  concat::fragment { "${name}-header":
    target  => $name,
    content => epp('asterisk/asterisk_conf_header.epp', {
      'module'   => $caller_module_name,
      'hostname' => $facts['networking']['hostname'],
      'template' => 'asterisk/asterisk_conf_header.epp'
    }),
    order   => '01',
  }

  concat::fragment { "${name}-std":
    target  => $name,
    content => epp($template,
      { 'sep'                      => $seperator,
        'is_template'              => false,
        'data'                     => $standardsettings,
        'array_separator'          => $array_separator,
        'special_separator_fields' => $special_separator_fields
      }),
    order   => '02',
  }

  if !empty($standardsettings2) {
    concat::fragment { "${name}-std2":
      target  => $name,
      content => epp($template,
        { 'sep'                      => $seperator,
          'is_template'              => false,
          'data'                     => $standardsettings2,
          'array_separator'          => $array_separator,
          'special_separator_fields' => $special_separator_fields
        }),
      order   => '02',
    }
  }

  $specialsettings.each |String $section, $container| {
    concat::fragment { "${name}-${section}":
      target  => $name,
      content => epp($template,
        { 'sep'                      => pick($container['sep'], '='),
          'is_template'              => pick($container['is_template'], false),
          'data'                     => { $section => $container['data'] },
          'array_separator'          => $array_separator,
          'special_separator_fields' => $special_separator_fields
        }),
      order   => '03',
    }
  }

  concat::fragment { "${name}-includes":
    target  => $name,
    content => inline_epp(
      '<%-
$includes.each |String $include| { -%>
#include <<%= $include %>/<%= $suffix %>>
<%}-%>
',
      {
        'includes' => $includes,
        'suffix'   => $includes_file_suffix,
      }),
  }

  if $manage_dotd_includes {
    asterisk::util::dotd { $name:
      additional_paths => $includes,
    }
  }
}
