use ExtUtils::MakeMaker;
my ($make_args);

# WriteMakefile params
$make_args = {
               'NAME' => 'Unix::Mgt',
               'AUTHOR' => 'Miko O\'Sullivan <miko@idocs.com>',
               'ABSTRACT' => 'Unix::Mgt - lightweight Unix management tools',
               'PL_FILES' => {},
               'EXE_FILES' => [],
               'VERSION_FROM' => 'lib/Unix/Mgt.pm',
               'LICENSE' => 'perl',
               'PREREQ_PM' => {
                                'IPC::System::Simple' => '1.25',
                                'Capture::Tiny' => '0.25',
                                'String::Util' => 0,
                                'Unix::SearchPathGuess' => '0.11'
                              }
             };


WriteMakefile(%$make_args);
