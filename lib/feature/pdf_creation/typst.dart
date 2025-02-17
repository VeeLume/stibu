import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:result_type/result_type.dart';
import 'package:stibu/appwrite.models.dart';
import 'package:stibu/main.dart';
import 'package:system_info2/system_info2.dart';

Future<Result<File, String>> createPdf(
  PrintTemplates template,
  Invoices invoice,
) async {
  // Get temp directory
  final tempDir = await getTemporaryDirectory();

  // Create data.json file
  final dataFile = File('${tempDir.path}/data.json');
  await dataFile.writeAsString(jsonEncode(invoice.toJson()));

  // Create template file
  final templateFile = File('${tempDir.path}/template.dart');
  await templateFile.writeAsString(template.content);

  // Get typest binary
  await ensureTypst();

  // Create pdf
  final pdfFile = File('${tempDir.path}/${template.filename ?? 'invoce'}.pdf');
  final result = await Process.run(
    '${(await getApplicationSupportDirectory()).path}/typst${Platform.isWindows ? '.exe' : ''}',
    [
      'compile',
      templateFile.path,
      pdfFile.path,
    ],
  );

  if (result.exitCode == 0) {
    log.info('Pdf created at ${pdfFile.path}');

    // Cleanup
    return Success(pdfFile);
  }

  return Failure('Failed to create pdf');
}

const _typstRepository =
    'https://github.com/typst/typst/releases/latest/download';

Future<Result<void, String>> ensureTypst() async {
  // get appdata directory
  final appDataDir = await getApplicationSupportDirectory();

  final arch = SysInfo.rawKernelArchitecture;
  final os = Platform.operatingSystem;

  log
    ..info('Kernel architecture: $arch')
    ..info('Operating system: $os');

  late final String fileName;
  switch (os) {
    case 'android':
    case 'linux':
      switch (arch) {
        case 'AMD64':
        case 'x86_64':
          fileName = 'typst-x86_64-unknown-linux-musl.tar.xz';
        case 'aarch64':
          fileName = 'typst-aarch64-unknown-linux-musl.tar.xz';
        case 'armv7':
          fileName = 'typst-armv7-unknown-linux-musleabi.tar.xz ';
        case 'riscv64':
          fileName = 'typst-riscv64gc-unknown-linux-gnu.tar.xz';
        default:
          return Failure('Unsupported architecture');
      }
    case 'ios':
    case 'macos':
      switch (arch) {
        case 'AMD64':
        case 'x86_64':
          fileName = 'typst-x86_64-apple-darwin.tar.xz';
        case 'aarch64':
          fileName = 'typst-aarch64-apple-darwin.tar.xz';
        default:
          return Failure('Unsupported architecture');
      }
    case 'windows':
      switch (arch) {
        case 'AMD64':
        case 'x86_64':
          fileName = 'typst-x86_64-pc-windows-msvc.zip';
        case 'aarch64':
          fileName = 'typst-aarch64-pc-windows-msvc.zip';
        default:
          return Failure('Unsupported architecture');
      }
    default:
      return Failure('Unsupported operating system');
  }

  // Check if typst exists
  final typst =
      File('${appDataDir.path}/typst${Platform.isWindows ? '.exe' : ''}');

  if (typst.existsSync()) {
    log.info('Typst already exists at ${typst.path}');
    return Success(null);
  }

  // Download typst from latest github release
  final url = Uri.parse('$_typstRepository/$fileName');

  final response = await HttpClient().getUrl(url);
  final download = await response.close();
  final file = File('${appDataDir.path}/$fileName');

  await download.pipe(file.openWrite());

  // Extract typst
  await Process.run('tar', ['xf', file.path, '-C', appDataDir.path]);
  final extracted = Directory(
    '${appDataDir.path}/${fileName.replaceAll('.tar.xz', '').replaceAll('.zip', '')}',
  );
  // move extracted files to appDataDir
  final extractedFiles =
      File('${extracted.path}/typst${Platform.isWindows ? '.exe' : ''}');
  await extractedFiles.copy(typst.path);

  // cleanup
  await extracted.delete(recursive: true);
  await file.delete();

  // Make typst executable
  if (!Platform.isWindows) {
    await Process.run('chmod', ['+x', typst.path]);
  }

  log.info('Typst downloaded and extracted to ${typst.path}');

  return Success(null);
}
