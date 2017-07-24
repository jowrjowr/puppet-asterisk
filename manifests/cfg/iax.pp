# Configure an IAX2 context and its options
#
# $ensure can be set to absent to remove the configuration file.
#
# $source is a puppet file source where the contents of the file can be found.
#
# $content is the textual contents of the file being created. This option is
# mutually exclusive with $source. The content is placed after the name of the
# context (which is $name) and so it should not include the context name
# definition.
#
define asterisk::cfg::iax (
  Hash $options,
  Enum['present', 'absent'] $ensure   = present,
) {

  asterisk::util::dotdfile { "iax_${name}.conf":
    ensure   => $ensure,
    dotd_dir => 'iax.d',
    content  => epp('asterisk/snippet/iax2_user_snippet.epp',
      {
        'iax_user_options' => $options,
        'iax_user'         => $name
      }
    ),
  }
}
