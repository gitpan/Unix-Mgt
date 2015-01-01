use strict;
use Module::Build;
my ($build, $params);


$params = {
            'dist_abstract' => 'Unix::Mgt - lightweight Unix management tools',
            'dist_author' => 'Miko O\'Sullivan <miko@idocs.com>',
            'module_name' => 'Unix::Mgt',
            'requires' => {
                            'IPC::System::Simple' => '1.25',
                            'Capture::Tiny' => '0.25',
                            'String::Util' => 0,
                            'Unix::SearchPathGuess' => '0.11'
                          },
            'dist_version_from' => 'lib/Unix/Mgt.pm',
            'license' => 'perl'
          };


$build = Module::Build->new(%$params);
$build->create_build_script();
