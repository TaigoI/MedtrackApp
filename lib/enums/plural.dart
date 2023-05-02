enum PluralProperty { singular, plural, pluralOptional }

class PluralController {

  static fromAmount(int amount){
    return (amount >=-1 && amount <= 1) ? PluralProperty.singular : PluralProperty.plural;
  }

}