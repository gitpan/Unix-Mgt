use ExtUtils::MakeMaker;
my ($make_args);

# WriteMakefile params
$make_args = {
               'AUTHOR' => 'Miko O\'Sullivan <miko@idocs.com>',
               'PL_FILES' => {},
               'LICENSE' => 'perl',
               'VERSION_FROM' => 'lib/Unix/Mgt.pm',
               'EXE_FILES' => [],
               'NAME' => 'Unix::Mgt',
               'PREREQ_PM' => {
                                'IPC::System::Simple' => '1.25',
                                'String::Util' => 0,
                                'Unix::SearchPathGuess' => '0.11',
                                'Capture::Tiny' => '0.25'
                              },
               'ABSTRACT' => 'Unix::Mgt - lightweight Unix management tools'
             };


WriteMakefile(%$make_args);
