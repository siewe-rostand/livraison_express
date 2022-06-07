
class OptionsConstant{
  static const id ='id';
  static const name = 'name';
  static const price = 'price';
  static const quantity = 'quantity';
}
class AttributeConstant{
  static const id = 'id';
  static const name = 'name';
  static const requiredChoiceQuota='requiredChoiceQuota';
}

class ProductConstant{
  static const id = 'id';
  static const name = 'libelle';
  static const magasinId = 'magasin_id';
  static const categoryId = 'categorie_id';
  static const unitPrice = 'prix_unitaire';
  static const quantity = 'quantite';
  static const preparationTime = 'duree_preparation';
  static const image = 'image';
  static const description = 'description';
  static const complement = 'complements';
}

class CityConstant{
  static const id = 'id';
  static const name = 'name';
  static const latitude = 'latitude';
  static const longitude = 'longitude';
  static const isActive = 'is_active';
}

class ModuleConstant{
  static const id='id';
  static const name='libelle';
  static const slug='slug';
  static const image='image';
  static const heureOverture='heure_ouverture';
  static const heureFermeture='heure_fermeture';
  static const isActive='is_active';
  static const isOpen='is_open';
  static const isActiveInCity='is_active_in_city';
  static const shops='shops';
  static const availableInCity='available_in_cities';
}
class MagasinConstant{
  static const id= 'id';
  static const moduleId= 'module_id';
  static const nom= 'nom';
  static const partenaire_id= 'partenaire_id';
  static const contact_id= 'contact_id';
  static const etablissement_id= 'etablissement_id';
  static const ville_id= 'ville_id';
  static const adresse_id= 'adresse_id';
  static const adresse= 'adresse';
  static const image= 'image';
  static const horaires= 'horaires';
  static const contact= 'contact';
  static const tags= 'tags';
  static const slug= 'slug';
  static const description= 'description';
  static const shipping_preparation_time= 'shipping_preparation_time';
}
class AddressConstant{
  static const id='id';
  static const title='titre';
  static const quarter='quartier';
  static const description='description';
  static const address='adresse';
  static const latitude='latitude';
  static const longitude='longitude';
  static const longitudeLatitude='longitude_latitude';
  static const ville='ville';
  static const pays='pays';
  static const creationDate='date_creation';
  static const modificationDate='date_modification';
  static const isFavorite='est_favorite';
}

class ClientConstant{
  static const id='id';
  static const fullName='fullname';
  static const name='name';
  static const surname='surname';
  static const telephone='telephone';
  static const telephoneAlt='telephone_alt';
  static const email='email';
  static const noteIterne='note_interne';
  static const addresses='adressess';
}

class DayConstant{
  static const enabled='enabled';
  static const opened='opened';
  static const openedAt='opened_at';
  static const closeAt='close_at';
  static const items='items';
  static const today='today';
  static const tomorrow='tomorrow';
  static const dayOfWeek='dayOfWeek';
  static const tomorrowDayOfWeek='tomorrowDayOfWeek';
}
