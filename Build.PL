use strict;
use Module::Build;
my ($build, $params);


$params = {
            'license' => 'perl',
            'dist_abstract' => 'Unix::Mgt - lightweight Unix management tools',
            'requires' => {
                            'IPC::System::Simple' => '1.25',
                            'String::Util' => 0,
                            'Unix::SearchPathGuess' => '0.11',
                            'Capture::Tiny' => '0.25'
                          },
            'module_name' => 'Unix::Mgt',
            'dist_version_from' => 'lib/Unix/Mgt.pm',
            'dist_author' => 'Miko O\'Sullivan <miko@idocs.com>'
          };


$build = Module::Build->new(%$params);
$build->create_build_script();
