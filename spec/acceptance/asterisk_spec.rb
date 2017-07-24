require 'spec_helper_acceptance'

describe 'asterisk' do
  context 'run without options' do
    manifest =
    <<-EOS
    include asterisk
    EOS

    run_manifest manifest

  end
end

