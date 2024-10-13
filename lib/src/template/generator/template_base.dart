abstract class IDartTemplateGenerator<TArg> {
  const IDartTemplateGenerator();

  Future<bool> generate(TArg args);
}
