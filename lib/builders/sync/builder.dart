import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'generator.dart';


Builder stateSyncBuilder(BuilderOptions options) =>
    SharedPartBuilder([StateGenerator()], 'sync');