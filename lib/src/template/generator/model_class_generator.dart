import '../../mixins/file_mixin.dart';
import '../../utils/common/paths.dart';
import '../../utils/common/constants.dart';
import '../../utils/extensions/column_data_exts.dart';
import '../../utils/extensions/string/name_formatting_extension.dart';
import '../../utils/models/column_data.dart';
import '../../utils/models/template_generator_args/model_class.dart';
import 'template_base.dart';

part '../model_class_template.dart';

final class ModelClassTemplateGenerator
    with FileMixin
    implements IDartTemplateGenerator<ModelClassTemplateArg> {
  const ModelClassTemplateGenerator._();
  static const shared = ModelClassTemplateGenerator._();

  @override
  Future<bool> generate(ModelClassTemplateArg args) async {
    final template = _ModelClassTemplate.shared.generate(
      args.fields,
      className: args.className,
    );

    write(
      filePath: Paths.shared.models,
      fileName: args.className.toDartFileNameWithExtension ??
          Constants.defModel.toDartFileNameWithExtension!,
      content: template.toString(),
    );

    return true;
  }
}
